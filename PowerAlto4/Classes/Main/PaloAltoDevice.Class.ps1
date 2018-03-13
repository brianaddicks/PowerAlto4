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

    [ValidateRange(1,65535)]
    [int]$Port = 443

    [ValidateSet('http','https')] 
    [string]$Protocol = "https"

    # Track usage
    hidden [bool]$Connected
    [array]$UrlHistory
    [array]$RawQueryResultHistory
    [array]$QueryHistory
    $LastError
    $LastResult
    
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
            $this.QueryHistory += $queryString
        } else {
            $this.UrlHistory += $url.Replace($queryString.password,"PASSWORDREDACTED")
            $this.QueryHistory += $queryString.Replace($queryString.password,"PASSWORDREDACTED")
        }

        # try query
        try {
            $rawResult = Invoke-WebRequest -Uri $url -SkipCertificateCheck
        } catch {
            Throw "$($error[0].ToString()) $($error[0].InvocationInfo.PositionMessage)"
        }

        $result                      = [xml]($rawResult.Content)
        $this.RawQueryResultHistory += $rawResult
        $this.LastResult             = $result

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

    # Operational API Query
    [xml] invokeOperationalQuery([string]$cmd) {
        $queryString = @{}
        $queryString.type = "op"
        $queryString.cmd = $cmd
        $result = $this.invokeApiQuery($queryString)
        return $result
    }

    # invokeConfigQuery
    [Xml] invokeConfigQuery([string]$action,[string]$xPath) {
        $queryString         = @{}
        $queryString.type    = "config"
        $queryString.action  = $action
        $queryString.xpath   = $xPath

        $result = $this.invokeApiQuery($queryString)
        return $result
    }
    

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