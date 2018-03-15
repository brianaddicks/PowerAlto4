function Invoke-PaCommit {
	<#
	.SYNOPSIS
		Commits Palo Alto configuration.
		
	.DESCRIPTION
		Commits Palo Alto configuration.

	.EXAMPLE
	#>
	[CmdletBinding(SupportsShouldProcess = $True)]

	Param (
	)

    BEGIN {
        $VerbosePrefix = "Invoke-PaCommit:"
        $Cmd = '<commit></commit>'
    }

    PROCESS {
        $CommandBeingRun = [regex]::split($Cmd, '[<>\/]+') | Select-Object -Unique | Where-Object { $_ -ne "" }
        if ($PSCmdlet.ShouldProcess("Running Operational Command: $CommandBeingRun")) {
            $global:PaDeviceObject.invokeCommitQuery($Cmd)
        }
    }
}