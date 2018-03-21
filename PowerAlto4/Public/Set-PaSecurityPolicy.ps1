function Set-PaSecurityPolicy {
	<#
	.SYNOPSIS
		Creates/Configures a Security Policy on a Palo Alto device.
		
	.DESCRIPTION
		Creates/Configures a Security Policy on a Palo Alto device.

	.EXAMPLE
		
	.PARAMETER Name
		
	#>
	[CmdletBinding(SupportsShouldProcess=$True)]

	Param (
        [Parameter(ParameterSetName="paobject",Mandatory=$True,Position=0,ValueFromPipeline=$True)]
        [PaSecurityPolicy]$PaSecurityPolicy
	)

    BEGIN {
        $Xpath = $Global:PaDeviceObject.createXPath('rulebase/security/rules',$null)
    }

    PROCESS {
        switch ($PsCmdlet.ParameterSetName) {
            'paobject' {
                $ConfigObject = $PaSecurityPolicy
            }
        }

        $ElementXml = $ConfigObject.ToXml().rules.entry.InnerXml

        if ($PSCmdlet.ShouldProcess("Creating new rule: $($ConfigObject.Name)")) {
            $Set = Invoke-PaApiConfig -Set -Xpath $XPath -Element $ElementXml

            $Set
        }
    }
}