function Get-PaNatPolicy {
	<#
	.SYNOPSIS
		Retrieve address objects from Palo Alto device.
		
	.DESCRIPTION
		Retrieve address objects from Palo Alto device.

    .EXAMPLE
		
	.PARAMETER Name
		
	#>
	[CmdletBinding()]

	Param (
		[Parameter(Mandatory=$False,Position=0)]
		[string]$Name
	)

    BEGIN {
        $VerbosePrefix = "Get-PaNat:"
        $XPathNode = 'rulebase/nat/rules'
        $ResponseNode = 'rules'
        $Xpath = $Global:PaDeviceObject.createXPath($XPathNode,$Name)
    }

    PROCESS {
        # Get the config info for the report
        # This is required for the call to run the report
        $Response = Invoke-PaApiConfig -Get -Xpath $XPath
        if ($Response.response.result.$ResponseNode) {
            $Entries = $Response.response.result.$ResponseNode.entry
        } else {
            $Entries = $Response.response.result.entry
        }

        $ReturnObject = @()
        foreach ($entry in $Entries) {
            # Initialize Report object, add to returned array
            $Object        = [PaNatPolicy]::new([HelperXml]::parseCandidateConfigXml($entry.name,$false))
            $ReturnObject += $Object

            # Add simple properties
            
            

            # General
            $Object.Description = [HelperXml]::parseCandidateConfigXml($entry.description,$false)
            $Object.NatType     = [HelperXml]::parseCandidateConfigXml($entry.'nat-type',$false)
            $Object.Tags        = [HelperXml]::parseCandidateConfigXml($entry.tag.member,$false)

            # Original Packet
            $Object.SourceZone           = [HelperXml]::parseCandidateConfigXml($entry.from.member,$false)
            $Object.DestinationZone      = [HelperXml]::parseCandidateConfigXml($entry.to.member,$false)
            $Object.DestinationInterface = [HelperXml]::parseCandidateConfigXml($entry.'to-interface',$false)
            $Object.Service              = [HelperXml]::parseCandidateConfigXml($entry.service,$false)
            $Object.SourceAddress        = [HelperXml]::parseCandidateConfigXml($entry.source.member,$false)
            $Object.DestinationAddress   = [HelperXml]::parseCandidateConfigXml($entry.destination.member,$false)

            # Translated Packet
            ## Static IP
            $SourceTranslationType = [HelperXml]::parseCandidateConfigXml($entry.'source-translation',$true)
            $Object.SourceTranslationType = $SourceTranslationType
            $Object.SourceTranslatedAddress = [HelperXml]::parseCandidateConfigXml($entry.'source-translation'.$SourceTranslationType.'translated-address',$false)
            
            $Bidirectional = [HelperXml]::parseCandidateConfigXml($entry.'source-translation'.$SourceTranslationType.'bi-directional',$false)
            if ($Bidirectional -eq 'yes') {
                $Object.BiDirectional = $true
            }            
            
            #$Object.TranslatedDestinationAddress
            #$Object.TranslatedDestinationPort
        }

        $ReturnObject
    }
}