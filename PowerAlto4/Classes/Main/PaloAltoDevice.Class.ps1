class PaloAltoDevice {
    [string]$Name
    [string]$Model
    [string]$Serial
    [string]$Hostname
    [string]$ApiKey

    # Verion info
    [string]$OsVersion
    [string]$GpAgent
    [string]$AppVersion
    [string]$ThreatVersion
    [string]$WildFireVersion
    [string]$UrlVersion

    # Settings
    [bool]$VsysEnabled

    [ValidateRange(1,65535)]
    [int]$Port = 443

    [ValidateSet('http','https')] 
    [string]$Protocol = "https"

    # Context Data
    [string]$Vsys = 'shared'

    # Track usage
    hidden [bool]$Connected
    [array]$UrlHistory
    [array]$RawQueryResultHistory
    [array]$QueryHistory
    $LastError
    $LastResult

    # Create XPath
    [string] createXPath ([string]$ConfigNode,[string]$Name) {
        $XPath = '/config'

        # choose correct vsys
        # this may need to be modified for systems that don't support vsys, PA-200s maybe?
        if ($this.VsysEnabled) {
            if ($this.Vsys -eq 'shared') {
                $XPath += '/shared'
            } else {
                $XPath +="/devices/entry/vsys/entry[@name='$($this.Vsys)']"
            }
        } else {
            $XPath +="/devices/entry/vsys/entry[@name='vsys1']"
        }

        # Add ConfigNode
        $XPath += "/$ConfigNode"

        if ($Name) {
            $XPath += "/entry[@name='$Name']"
        }

        return $XPath
    }

    # Create query string
    static [string] createQueryString ([hashtable]$hashTable) {
        $i = 0
        $queryString = "?"
        foreach ($hash in $hashTable.GetEnumerator()) {
            $i++
            $queryString += $hash.Name + "=" + $hash.Value
            if ($i -lt $HashTable.Count) {
                $queryString += "&"
            }
        }
        return $queryString
    }

    # Generate Api URL
    [String] getApiUrl([string]$formattedQueryString) {
        if ($this.Hostname) {
            $url = "https://" + $this.Hostname + "/api/" + $formattedQueryString
            return $url
        } else {
            return $null
        }
    }

    ##################################### Main Api Query Function #####################################
    # invokeApiQuery
    [xml] invokeApiQuery([hashtable]$queryString) {
        # If the query is not a keygen query we need to append the apikey to the query string
        if ($queryString.type -ne "keygen") {
            $queryString.key = $this.ApiKey
        }

        # format the query string and general the full url
        $formattedQueryString = [HelperWeb]::createQueryString($queryString)
        $url                  = $this.getApiUrl($formattedQueryString)

        # Populate Query/Url History
        # Redact password if it's a keygen query
        if ($queryString.type -ne "keygen") {
            $this.UrlHistory += $url
        } else {
            $this.UrlHistory += $url.Replace($queryString.password,"PASSWORDREDACTED")
            $queryString.password = $queryString.password,"PASSWORDREDACTED"
        }

        # add query object to QueryHistory
        $this.QueryHistory += $queryString

        # try query
        try {
            $rawResult = Invoke-WebRequest -Uri $url -SkipCertificateCheck -UseBasicParsing
        } catch {
            Throw "$($error[0].ToString()) $($error[0].InvocationInfo.PositionMessage)"
        }

        $result                      = [xml]($rawResult.Content)
        $this.RawQueryResultHistory += $rawResult
        $this.LastResult             = $result

        $proccessedResult = $this.processQueryResult($result)
        
        return $proccessedResult
    }

    # processQueryResult
    [xml] processQueryResult ([xml]$unprocessedResult) {
        $result = $null

        switch ($unprocessedResult.response.status) {
            'success' {
                $result = $unprocessedResult
            }
            'error' {
                if ($unprocessedResult.response.msg.line) {
                    $Message = $unprocessedResult.response.msg.line.'#cdata-section' -join "`r`n"
                } else {
                    $Message = $unprocessedResult.response.msg
                }
                Throw $Message
            }
        }

        return $result
    }

    # Keygen API Query
    [xml] invokeKeygenQuery([PSCredential]$credential) {
        $queryString = @{}
        $queryString.type = "keygen"
        $queryString.user = $credential.UserName
        $queryString.password = $Credential.getnetworkcredential().password
        $result = $this.invokeApiQuery($queryString)
        $this.ApiKey = $result.response.result.key
        return $result
    }
    
    # Commit API Query
    [xml] invokeCommitQuery([string]$cmd) {
        $queryString = @{}
        $queryString.type = "commit"
        $queryString.cmd = $cmd
        $result = $this.invokeApiQuery($queryString)
        return $result
    }

    # Operational API Query
    [xml] invokeOperationalQuery([string]$cmd) {
        $queryString = @{}
        $queryString.type = "op"
        $queryString.cmd = $cmd
        $result = $this.invokeApiQuery($queryString)
        return $result
    }

    # invokeConfigQuery without element
    [Xml] invokeConfigQuery([string]$action,[string]$XPath) {
        $queryString         = @{}
        $queryString.type    = "config"
        $queryString.action  = $action
        $queryString.xpath   = $xPath

        $result = $this.invokeApiQuery($queryString)
        return $result
    }

    # invokeConfigQuery with element
    [Xml] invokeConfigQuery([string]$action,[string]$XPath,[string]$Element) {
        $queryString         = @{}
        $queryString.type    = "config"
        $queryString.action  = $action
        $queryString.xpath   = $XPath
        $queryString.element = $Element

        $result = $this.invokeApiQuery($queryString)
        return $result
    }

    # invokeReportQuery
    [Xml] invokeReportQuery([string]$ReportType,[string]$ReportName,[string]$Cmd) {
        $queryString            = @{}
        $queryString.type       = "report"
        $queryString.reporttype = $ReportType
        $queryString.reportname = $ReportName
        $queryString.cmd        = $Cmd

        $result = $this.invokeApiQuery($queryString)
        return $result
    }

    # invokeReportGetQuery
    [Xml] invokeReportGetQuery([int]$JobId) {
        $queryString          = @{}
        $queryString.type     = "report"
        $queryString.action   = "get"
        $queryString.'job-id' = $JobId

        $result = $this.invokeApiQuery($queryString)
        return $result
    }

    #  https://<firewall>/api/?type=report&action=get&job-id=jobid

    # Test Connection
    [bool] testConnection() {
        $result = $this.invokeOperationalQuery('<show><system><info></info></system></show>')
        $this.Connected       = $true
        $this.Name            = $result.response.result.system.devicename
        $this.Hostname        = $result.response.result.system.'ip-address'
        $this.Model           = $result.response.result.system.model
        $this.Serial          = $result.response.result.system.serial
        $this.OsVersion       = $result.response.result.system.'sw-version'
        $this.GpAgent         = $result.response.result.system.'global-protect-client-package-version'
        $this.AppVersion      = $result.response.result.system.'app-version'
        $this.ThreatVersion   = $result.response.result.system.'threat-version'
        $this.WildFireVersion = $result.response.result.system.'wildfire-version'
        $this.UrlVersion      = $result.response.result.system.'url-filtering-version'
        if ($result.response.result.system.'multi-vsys' -eq 'on') {
            $this.VsysEnabled = $true
        } else {
            $this.VsysEnabled = $false
        }
        return $true
    }

    ##################################### Initiators #####################################
    # Initiator with apikey
    PaloAltoDevice([string]$Hostname,[string]$ApiKey) {
        $this.Hostname = $Hostname
        $this.ApiKey = $ApiKey
    }

    # Initiator with Credential
    PaloAltoDevice([string]$Hostname,[PSCredential]$Credential) {
        $this.Hostname = $Hostname
        $this.invokeKeygenQuery($Credential)
    }
}