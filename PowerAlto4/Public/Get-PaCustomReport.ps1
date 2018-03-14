function Get-PaCustomReport {
	<#
	.SYNOPSIS
		Gets configuration of custom reports from a Palo Alto device.
		
	.DESCRIPTION
		Gets configuration of custom reports from a Palo Alto device.

	.EXAMPLE
		
	.PARAMETER Name
		

    .PARAMETER Vsys
		
	#>
	[CmdletBinding()]

	Param (
		[Parameter(Mandatory=$False,Position=0)]
		[string]$Name,

		[Parameter(Mandatory=$False,Position=1)]
		[string]$Vsys
	)

    BEGIN {
        $VerbosePrefix = "Get-PaCustomReport:"
        $ReportXPath = '/config'
        
        if (!($Vsys)) {
            $ReportXPath += "/shared"
        } else {
            $ReportXPath += "/devices/entry/vsys/entry[@name='$Vsys']"
        }

        $ReportXPath += '/reports'

        if ($Name) {
            $ReportXPath += "/entry[@name='$Name']"
        }
    }

    PROCESS {
        # Get the config info for the report
        # This is required for the call to run the report
        $ReportConfig = Invoke-PaApiConfig -Get -Xpath $ReportXPath

        $ReturnObject = @()
        foreach ($entry in $ReportConfig.response.result.reports.entry) {
            # Initialize Report object, add to returned array
            $Database      = ($entry.type | Get-Member -Type Property).Name
            Write-Verbose "$VerbosePrefix adding report: Name $($entry.name), Database $Database"
            $Report        = [PaCustomReport]::new($entry.name)
            $ReturnObject += $Report
            
            # Add other properties to report
            $Report.Database     = $Database
            $Report.FirstColumn  = $entry.type.trsum.'aggregate-by'.member
            $Report.Members      = $entry.type.trsum.values.member
            $Report.TimeFrame    = $entry.period
            $Report.EntriesShown = $entry.topn
            $Report.Groups       = $entry.topm
        }

        $ReturnObject
    }
}