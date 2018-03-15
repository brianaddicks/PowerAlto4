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
        if ($ReportConfig.response.results.reports) {
            $Entries = $ReportConfig.response.result.reports.entry
        } else {
            $Entries = $ReportConfig.response.result.entry
        }

        $ReturnObject = @()
        foreach ($entry in $Entries) {
            $Global:entrytest = $entry
            # Initialize Report object, add to returned array
            $Report        = [PaCustomReport]::new($entry.name)
            $ReturnObject += $Report

            # Get Node Name Properties
            $Report.Database = [HelperXml]::parseCandidateConfigXml($entry.type,$true)
            Write-Verbose "$VerbosePrefix adding report: Name $($entry.name), Database $($Report.Database)"

            
            
            # Add other properties to report
            $Report.FirstColumn  = [HelperXml]::parseCandidateConfigXml($entry.type.trsum.'aggregate-by'.member,$false)
            $Report.Members      = [HelperXml]::parseCandidateConfigXml($entry.type.trsum.values.member,$false)
            $Report.TimeFrame    = [HelperXml]::parseCandidateConfigXml($entry.period,$false)
            $Report.EntriesShown = [HelperXml]::parseCandidateConfigXml($entry.topn,$false)
            $Report.Groups       = [HelperXml]::parseCandidateConfigXml($entry.topm,$false)
        }

        $ReturnObject
    }
}