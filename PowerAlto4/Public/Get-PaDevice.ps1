function Get-PaDevice {
	<#
	.SYNOPSIS
		Establishes initial connection to Palo Alto API.
		
	.DESCRIPTION
		The Get-PaDevice cmdlet establishes and validates connection parameters to allow further communications to the Palo Alto API. The cmdlet needs at least two parameters:
		 - The device IP address or FQDN
		 - A valid API key or PSCredential object
		
		The cmdlet returns an object containing details of the connection, but this can be discarded or saved as desired; the returned object is not necessary to provide to further calls to the API.
	
	.EXAMPLE
		Get-PaDevice -DeviceAddress "pa.example.com" -ApiKey "LUFRPT1asdfPR2JtSDl5M2tjfdsaTktBeTkyaGZMTURasdfTTU9BZm89OGtKN0F"
		
		Connects to Palo Alto Device using the default port (443) over SSL (HTTPS) using an API Key
	.EXAMPLE
		Get-PaDevice -DeviceAddress "pa.example.com" -Credential (Get-Credential)

		Prompts the user for username and password and connects to the Palo Alto Device with those creds.  This will generate a keygen call and the user's API Key will be used for all subsequent calls.
	.PARAMETER DeviceAddress
		Fully-qualified domain name for the Palo Alto Device. Don't include the protocol ("https://" or "http://").

    .PARAMETER ApiKey
		ApiKey used to access Palo Alto Device.
		
	.PARAMETER Credential
		PSCredental object to provide as an alternative to an API Key.
	
	.PARAMETER Port
		The port the Palo Alto Device is using for management communicatins. This defaults to port 443 over HTTPS, and port 80 over HTTP.
	
	.PARAMETER HttpOnly
		When specified, configures the API connection to run over HTTP rather than the default HTTPS. Not recommended!
	
    .PARAMETER SkipCertificateCheck
		When used, all certificate warnings are ignored.

    .PARAMETER Quiet
		When used, the cmdlet returns nothing on success.
	#>
	[CmdletBinding(DefaultParameterSetName = 'ApiKey')]

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[ValidatePattern("\d+\.\d+\.\d+\.\d+|(\w\.)+\w")]
		[string]$DeviceAddress,

        [Parameter(ParameterSetName="ApiKey",Mandatory=$True,Position=1)]
        [string]$ApiKey,

        [Parameter(ParameterSetName="Credential",Mandatory=$True,Position=1)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

		[Parameter(Mandatory=$False,Position=2)]
		[int]$Port = 443,

		[Parameter(Mandatory=$False)]
		[alias('http')]
		[switch]$HttpOnly,
        
		[Parameter(Mandatory=$False)]
		[switch]$SkipCertificateCheck,

        [Parameter(Mandatory=$False)]
		[alias('q')]
		[switch]$Quiet
	)

    BEGIN {
		$VerbosePrefix = "Get-PaDevice:"

		if ($HttpOnly) {
			$Protocol = "http"
			if (!$Port) { $Port = 80 }
		} else {
			$Protocol = "https"
			if (!$Port) { $Port = 443 }
			
			#$global:PaDeviceObject = New-Object PaloAltoDevice
            #$global.$global:PaDeviceObject.Hostname = $DeviceAddress
			#$global:PaDeviceObject.Protocol = $Protocol
            #$global:PaDeviceObject.Port     = $Port
			

            
		}
    }

    PROCESS {
        
        if (!($ApiKey)) {
            Write-Verbose "$VerbosePrefix Attempting to generate API Key."
			#$global:PaDeviceObject.invokeKeygenQuery($Credential)
            Write-Verbose "$VerbosePrefix API Key successfully generated."
		}
		
		if ($ApiKey) {
			Write-Verbose "$VerbosePrefix Attempting to generate API Key."
			$global:PaDeviceObject = [PaloAltoDevice]::new($DeviceAddress,$ApiKey)
			Write-Verbose "$VerbosePrefix API Key successfully generated."
		}
		
		# Test API connection
		# When generating an api key, the connection is already tested.
		# This grabs serial/version info from the box and tests if you're just
		# supplying an api key yourself.
		$global:PaDeviceObject = [PaloAltoDevice]::new($DeviceAddress,$Credential)

        if (!($Quiet)) {
            return $global:PaDeviceObject
        }
    }
}