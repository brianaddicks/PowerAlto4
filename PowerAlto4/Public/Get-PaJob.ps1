function Get-PaJob {
	<#
	.SYNOPSIS
		Gets job status from Palo Alto Device.
		
	.DESCRIPTION
		Gets job status from Palo Alto Device.
	#>
	[CmdletBinding(SupportsShouldProcess = $True)]

	Param (
        [Parameter(ParameterSetName="alljobs",Mandatory=$False,Position=0)]
        [Parameter(ParameterSetName="singlejob",Mandatory=$False,Position=0)]
        [int]$JobId,
        
        [Parameter(ParameterSetName="singlejob",Mandatory=$False)]
		[switch]$Wait,
        
        [Parameter(ParameterSetName="singlejob",Mandatory=$False)]
		[switch]$ShowProgress
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
            $Job = [PaJob]::new($result.id)
            $ReturnObject += $Job

            $Job.Enqueued     = Get-Date $result.tenq
            $Job.Dequeued     = Get-Date $result.tdeq
            $Job.Type         = $result.type
            $Job.Status       = $result.status
            $Job.Result       = $result.result
            $Job.Warnings     = $result.warnings -join "`r`n"
            $Job.Details      = $result.details.line -join "`r`n"
            $Job.Description  = $result.description
            $Job.User         = $result.user
            $Job.Progress     = $result.progress
            if ($Job.Progress -eq 100) {
                $Job.TimeComplete = Get-Date $result.tfin
            }
        }

        if (($Wait -or $ShowProgress) -and ($Job.Progress -ne 100)) {
            Write-Verbose "$VerbosePrefix Job not complete"
            
            # Wait 10 seconds and check again
            do {
                if ($ShowProgress) {
                    $ProgressParams = @{}
                    $ProgressParams.Activity = "Checking Commit Status..."
                    $ProgressParams.CurrentOperation = "Waiting to Contact Device..."
                    $ProgressParams.SecondsRemaining = 10
                    $ProgressParams.PercentComplete = $Job.Progress
                    $ProgressParams.Status = "$($Job.Progress) %"
                    Write-Progress @ProgressParams
                    for ($i = 1;$i -le 10; $i++) {
                        Start-Sleep -Seconds 1
                        $ProgressParams.SecondsRemaining = 10 - $i
                        Write-Progress @ProgressParams
                    }
                    $ProgressParams.CurrentOperation = "Contacting Device..."
                    Write-Progress @ProgressParams
                } else {
                    Start-Sleep -Seconds 10
                }
                Write-Verbose "$VerbosePrefix Checking again"
                $Job = Get-PaJob -JobId $JobId
                $ProgressParams.PercentComplete = $Job.Progress
                $ProgressParams.Status = "$($Job.Progress) %"
                Write-Progress @ProgressParams
                Write-Verbose "$VerbosePrefix Progress: $($Job.Progress)"

            } while ($Job.Status -ne 'FIN')

            $ReturnObject = $Job
        }

        $ReturnObject
    }
}