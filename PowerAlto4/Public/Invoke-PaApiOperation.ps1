function Invoke-PaApiOperation {
	<#
	.SYNOPSIS
		Invokes the Palo Alto Operation Api.
		
	.DESCRIPTION
		Invokes the Palo Alto Operation Api.

	.EXAMPLE
		
	.PARAMETER Cmd
		Operational command to run.
	#>
	[CmdletBinding(SupportsShouldProcess = $True)]

	Param (
		[Parameter(Mandatory=$True,Position=0)]
        [string]$Cmd
	)

    BEGIN {
		$VerbosePrefix = "Invoke-PaApiOperation:"
    }

    PROCESS {
        $CommandBeingRun = [regex]::split($Cmd, '[<>\/]+') | Select-Object -Unique | Where-Object { $_ -ne "" }
        if ($PSCmdlet.ShouldProcess("Running Operational Command: $CommandBeingRun")) {
            $global:PaDeviceObject.invokeOperationalQuery($Cmd)
        }
    }
}