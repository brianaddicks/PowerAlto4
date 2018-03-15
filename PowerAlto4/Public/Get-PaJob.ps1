function Get-PaJob {
	<#
	.SYNOPSIS
		Gets job status from Palo Alto Device.
		
	.DESCRIPTION
		Gets job status from Palo Alto Device.
	#>
	[CmdletBinding(SupportsShouldProcess = $True)]

	Param (
        [Parameter(Mandatory=$False,Position=0)]
		[int]$JobId
	)

    BEGIN {
        $VerbosePrefix = "Get-PaJob:"
        $Cmd = '<show><jobs>'
        if ($JobId) {
            $Cmd += '<id>' + $JobId + '</id>'
        } else {
            $Cmd += '<all/>'
        }
        $Cmd += '</jobs></show>'
    }

    PROCESS {
        $Query = Invoke-PaApiOperation -Cmd $Cmd
        $Results = $Query.response.result.job

        $ReturnObject = @()
        foreach ($result in $Results) {
            $global:testresult = $result
            $Job = [PaJob]::new($result.id)
            $ReturnObject += $Job

            $Job.Enqueued     = Get-Date $result.tenq
            $Job.Dequeued     = Get-Date $result.tdeq
            $Job.Type         = $result.type
            $Job.Status       = $result.status
            $Job.Result       = $result.result
            $Job.TimeComplete = Get-Date $result.tfin
            $Job.Warnings     = $result.warnings
            $Job.Details      = $result.details.line -join "`r`n"
            $Job.Description  = $result.description
            $Job.User         = $result.user
            $Job.Progress     = $result.progress
        }

        $ReturnObject
    }
}