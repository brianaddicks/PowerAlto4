function Invoke-PaApiConfig {
	<#
	.SYNOPSIS
		Invokes a Palo Alto Config Api.
		
	.DESCRIPTION
		Invokes a Palo Alto Config Api.

	.EXAMPLE
		Invoke-PaApiConfig -Action "get" -XPath "/config/devices/entry[@name='localhost.localdomain']/network/interface"

		Returns interface configuration for the currently connected Palo Alto Device.
	.PARAMETER Action
		Action to use for the Api Config Call (get, set, rename currently supported)

    .PARAMETER XPath
		XPath of desired configuration.
	#>
	[CmdletBinding(DefaultParameterSetName = 'get')]

	Param (
        # get parameters
		[Parameter(ParameterSetName="get",Mandatory=$True,Position=0)]
        [switch]$Get,
        
        # set parameters
		[Parameter(ParameterSetName="set",Mandatory=$True,Position=0)]
        [switch]$Set,

        [Parameter(ParameterSetName="set",Mandatory=$True,Position=1)]
        [string]$Element,

        # all parametersets
		[Parameter(Mandatory=$True,Position=1)]
		[string]$XPath
	)

    BEGIN {
		$VerbosePrefix = "Invoke-PaApiConfig:"
    }

    PROCESS {
        switch ($PsCmdlet.ParameterSetName) {
            'get' {
                $Global:PaDeviceObject.invokeConfigQuery('get',$Xpath)
            }
            'set' {
                $Global:PaDeviceObject.invokeConfigQuery('set',$Xpath,$Element)
            }
        }
		
    }
}