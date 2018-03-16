function Get-PaCustomReport {
	<#
	.SYNOPSIS
		Wrapper for -WhatIf output, like Write-Verbose
		
	.DESCRIPTION
		Wrapper for -WhatIf output, like Write-Verbose

    .EXAMPLE
        Write-WhatIf "This is what happens when you do a thing."
		
	.PARAMETER Message
		What you want to output when -WhatIf is specified.
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
        $Xpath = $Global:PaDeviceObject.createXPath('reports',$Name)
    }

    PROCESS {
        # Get the config info for the report
        # This is required for the call to run the report
        $ReportConfig = Invoke-PaApiConfig -Get -Xpath $XPath
        if ($ReportConfig.response.result.reports) {
            $Entries = $ReportConfig.response.result.reports.entry
        } else {
            $Entries = $ReportConfig.response.result.entry
        }

        $ReturnObject = @()
        foreach ($entry in $Entries) {
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
            $Report.Description  = [HelperXml]::parseCandidateConfigXml($entry.description,$false)
        }

        $ReturnObject
    }
}