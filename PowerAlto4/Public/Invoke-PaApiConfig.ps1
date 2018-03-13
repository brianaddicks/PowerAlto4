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
	[CmdletBinding()]

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[ValidateSet("get")]
		[string]$Action = "get",

		[Parameter(Mandatory=$True,Position=1)]
		[string]$XPath
	)

    BEGIN {
		$VerbosePrefix = "Invoke-PaApiConfig:"
    }

    PROCESS {
		$Global:PaDeviceObject.invokeConfigQuery($Action,$Xpath)
    }
}