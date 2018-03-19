function Set-PaAddress {
	<#
	.SYNOPSIS
		Creates/Configures an address object on a Palo Alto device.
		
	.DESCRIPTION
		Creates/Configures an address object on a Palo Alto device.

	.EXAMPLE
		
	.PARAMETER Name
		
	#>
	[CmdletBinding(SupportsShouldProcess=$True)]

	Param (
		[Parameter(Mandatory=$True,Position=0)]
        [string]$Name,

        [Parameter(ParameterSetName="ip-netmask",Mandatory=$True)]
        [string]$IpNetmask,
        
        [Parameter(ParameterSetName="ip-range",Mandatory=$True)]
        [string]$IpRange,
        
        [Parameter(ParameterSetName="fqdn",Mandatory=$True)]
		[string]$Fqdn,
        
        [Parameter(Mandatory=$False)]
        [string]$Description,
        
        [Parameter(Mandatory=$False)]
		[array]$Tags
	)

    BEGIN {
        $Xpath = $Global:PaDeviceObject.createXPath('address',$Name)
    }

    PROCESS {

        $ConfigObject = [PaAddress]::new($Name)

        $ConfigObject.Description = $Description
        $ConfigObject.Type        = $PsCmdlet.ParameterSetName
        $ConfigObject.Tags        = $Tags

        switch ($PsCmdlet.ParameterSetName) {
            'ip-netmask' {
                $ConfigObject.Value = [HelperRegex]::isIpv4($IpNetmask,"IpNetmask must be a valid CIDR range or Ip Address. Ex: 10.0.0.0/16")
            }
            'ip-range' {
                $ConfigObject.Value = [HelperRegex]::isIpv4Range($IpRange,"IpRange must be a valid Ip Range. Ex: 192.168.1.1-192.168.1.250")
            }
            'fqdn' {
                $ConfigObject.Value = [HelperRegex]::isFqdn($Fqdn,"Fqdn must be a valid Fully Qualified Domain Name. Ex: contoso.com")
            }
        }

        $ElementXml = $ConfigObject.ToXml().address.entry.InnerXml

        if ($PSCmdlet.ShouldProcess("Creating new report: $($ConfigObject.Name)")) {
            $Set = Invoke-PaApiConfig -Set -Xpath $XPath -Element $ElementXml

            $Set
        }
    }
}