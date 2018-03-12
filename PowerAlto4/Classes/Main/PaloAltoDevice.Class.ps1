class PaloAltoDevice {
    [string]$Model
    [string]$Hostname
    [string]$ApiKey

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
    [String] getApiUrl() {
        if ($this.DeviceAddress) {
            #$url = $this.Protocol + "://" + $this.getDeviceAddress() + ":" + $this.Port + "/api/"
            $url = "https://" + $this.Hostname + "/api/"
            return $url
        } else {
            return $null
        }
    }

    # Invoke Api Query
    [xml] invokeApiQuery([hashtable]$queryString) {
        $formattedQueryString = [HelperWeb]::createQueryString($queryString)
        $url = $this.getApiUrl() + $formattedQueryString

        # keygen query or not?
        if ($queryString.type -ne "keygen") {
            return $null
        } else {
            $this.UrlHistory += $url.Replace($queryString.password,"PASSWORDREDACTED")
            return $null
        }

        # try query
        try {
            #$ProgressPreferenceRemember = $ProgressPreference
	        $ProgressPreference = "SilentlyContinue"
            $rawResult = Invoke-WebRequest -Uri $url -SkipCertificateCheck
            #$this.Connected = $true
            #$env:ProgressPreference = $ProgressPreferenceRemember
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


    # Initiator with Credential
    PaloAltoDevice([string]$Hostname,[PSCredential]$Credential) {
        $this.Hostname = $Hostname
        $this.invokeKeygenQuery($Credential)
    }
}