function Invoke-PaCustomReport {
	<#
	.SYNOPSIS
		Runs a Custom Palo Alto Report and retrieves results.
		
	.DESCRIPTION
		Runs a Custom Palo Alto Report and retrieves results.

	.EXAMPLE
		
	.PARAMETER Name
		

    .PARAMETER Vsys
		
	#>
	[CmdletBinding()]

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[string]$Name,

		[Parameter(Mandatory=$False,Position=1)]
		[string]$Vsys
	)

    BEGIN {
        $VerbosePrefix = "Invoke-PaCustomReport:"
        # /config/devices/ entry/vsys/entry[@name='vsys1']/reports/entry[@name='report-abc']
        # /config/shared/reports/entry[@name='ltg_overall-traffic']
        $ReportXPath = '/config/'
        
        if (!($Vsys)) {
            $ReportXPath += "shared/"
        } else {
            $ReportXPath += "devices/entry/vsys/entry[@name='$Vsys']/"
        }

        $ReportXPath += "reports/entry[@name='$Name']"
    }

    PROCESS {
        # Get the config info for the report
        # This is required for the call to run the report
        $ReportConfig = $Global:PaDeviceObject.invokeConfigQuery("get",$ReportXPath)
        
        # Extract the required xml
        $ReportXml = $ReportConfig.response.result.entry.InnerXml

        # Initiate the Report Job
        $ReportParams = @{}
        $ReportParams.ReportType = 'dynamic'
        $ReportParams.ReportName = $Name
        $ReportParams.Cmd        = $ReportXml
        $ReportResults           = Invoke-PaApiReport @ReportParams
        $JobId                   = $ReportResults.response.result.job

        # https://<firewall>/api/?type=report&action=get&job-id=jobid

        $GetJob = $Global:PaDeviceObject.invokeReportGetQuery($JobId)
        
        return $GetJob
    }
}