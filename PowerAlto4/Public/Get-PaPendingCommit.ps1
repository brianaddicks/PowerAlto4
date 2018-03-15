function Get-PaPendingCommit {
	<#
	.SYNOPSIS
		Checks to see if there's a difference in the candidate and running configuration on a Palo Alto Device.
		
	.DESCRIPTION
		Checks to see if there's a difference in the candidate and running configuration on a Palo Alto Device.

    .EXAMPLE
	#>
	[CmdletBinding()]

	Param (
	)

    BEGIN {
        $RunningConfig   = Invoke-PaApiOperation '<show><config><running/></config></show>'
        $CandidateConfig = Invoke-PaApiOperation '<show><config><candidate/></config></show>'
    }

    PROCESS {
        $ReturnObject = $RunningConfig -eq $CandidateConfig

        $ReturnObject
    }
}