function Get-PaSecurityPolicy {
	<#
	.SYNOPSIS
		Retrieve Security Policies from Palo Alto device.
		
	.DESCRIPTION
		Retrieve Security Policies from Palo Alto device.

    .EXAMPLE
		
	.PARAMETER Name
		
	#>
	[CmdletBinding()]

	Param (
        [Parameter(ParameterSetName="rulebase",Mandatory=$False,Position=0)]
        [Parameter(ParameterSetName="prerulebase",Mandatory=$False,Position=0)]
        [Parameter(ParameterSetName="postrulebase",Mandatory=$False,Position=0)]
        [string]$Name,
        
        [Parameter(ParameterSetName="prerulebase",Mandatory=$True)]
		[switch]$PreRulebase,
        
        [Parameter(ParameterSetName="postrulebase",Mandatory=$True)]
		[switch]$PostRulebase
	)

    BEGIN {
        $VerbosePrefix = "Get-PaSecurityPolicy:"
        
        # get the right xpath (panorama vs regular)
        switch ($PsCmdlet.ParameterSetName) {
            'postrulebase' {
                $XPathNode = 'post-rulebase/security/rules'
            }
            'prerulebase' {
                $XPathNode = 'pre-rulebase/security/rules'
            }
            'rulebase' {
                $XPathNode = 'rulebase/security/rules'
            }
        }

        $ResponseNode = 'rules'
        $Xpath = $Global:PaDeviceObject.createXPath($XPathNode,$null)
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
        $i = 0
        foreach ($entry in $Entries) {
            $i++
            # Initialize object, add to returned array
            $Object        = [PaSecurityPolicy]::new([HelperXml]::parseCandidateConfigXml($entry.name,$false))
            $ReturnObject += $Object


            # General
            $Object.Number      = $i
            $Object.RuleType    = [HelperXml]::parseCandidateConfigXml($entry.'rule-type',$false)
            $Object.Description = [HelperXml]::parseCandidateConfigXml($entry.description,$false)
            $Object.Tags        = [HelperXml]::parseCandidateConfigXml($entry.tag.member,$false)

            # Source
            $Object.SourceZone    = [HelperXml]::parseCandidateConfigXml($entry.from.member,$false)
            $Object.SourceAddress = [HelperXml]::parseCandidateConfigXml($entry.source.member,$false)

            # User
            $Object.SourceUser = [HelperXml]::parseCandidateConfigXml($entry.'source-user'.member,$false)
            $Object.HipProfile = [HelperXml]::parseCandidateConfigXml($entry.'hip-profiles'.member,$false)

            # Destination
            $Object.DestinationZone    = [HelperXml]::parseCandidateConfigXml($entry.to.member,$false)
            $Object.DestinationAddress = [HelperXml]::parseCandidateConfigXml($entry.destination.member,$false)

            # Application
            $Object.Application = [HelperXml]::parseCandidateConfigXml($entry.application.member,$false)

            # Service/Url Category
            $Object.Service = [HelperXml]::parseCandidateConfigXml($entry.service.member,$false)
            $Object.UrlCategory = [HelperXml]::parseCandidateConfigXml($entry.category.member,$false)

            # Actions
            ## Action Setting
            $Object.Action              = [HelperXml]::parseCandidateConfigXml($entry.action,$false)
            $Object.SendIcmpUnreachable = [HelperXml]::parseCandidateConfigXml($entry.'icmp-unreachable',$false)
            
            ## Profile Setting
            $Object.ProfileType = [HelperXml]::parseCandidateConfigXml($entry.'profile-setting',$true)
            switch ($Object.ProfileType) {
                'group' {
                    $Object.GroupProfile = [HelperXml]::parseCandidateConfigXml($entry.group.member,$false)
                }
                'profiles' {
                    $Object.Antivirus               = [HelperXml]::parseCandidateConfigXml($entry.virus.member,$false)
                    $Object.VulnerabilityProtection = [HelperXml]::parseCandidateConfigXml($entry.vulnerability.member,$false)
                    $Object.AntiSpyware             = [HelperXml]::parseCandidateConfigXml($entry.spyware.member,$false)
                    $Object.UrlFiltering            = [HelperXml]::parseCandidateConfigXml($entry.'url-filtering'.member,$false)
                    $Object.FileBlocking            = [HelperXml]::parseCandidateConfigXml($entry.'file-blocking'.member,$false)
                    $Object.DataFiltering           = [HelperXml]::parseCandidateConfigXml($entry.'data-filtering'.member,$false)
                    $Object.WildFireAnalysis        = [HelperXml]::parseCandidateConfigXml($entry.'wildfire-analysis'.member,$false)
                }
            }

            ## Log Setting
            $Object.LogAtSessionStart = [HelperXml]::parseCandidateConfigXml($entry.'log-start',$false)
            $Object.LogForwarding     = [HelperXml]::parseCandidateConfigXml($entry.'log-setting',$false)

            $LogEnd = [HelperXml]::parseCandidateConfigXml($entry.'log-end',$false)
            if ($LogEnd) {
                $Object.LogAtSessionEnd = $LogEnd
            }

            ## Other Settings
            $Object.Schedule = [HelperXml]::parseCandidateConfigXml($entry.schedule,$false)
            $Object.Dsri     = [HelperXml]::parseCandidateConfigXml($entry.option.'disable-server-response-inspection',$false)

            $QosFollowC2S    = [HelperXml]::parseCandidateConfigXml($entry.marking.'follow-c2s-flow',$true)
            $QosIpPrecedence = [HelperXml]::parseCandidateConfigXml($entry.marking.'ip-precedence',$false)
            $QosIpDscp       = [HelperXml]::parseCandidateConfigXml($entry.marking.'ip-dscp',$false)

            if ($QosFollowC2S) {
                $Object.QosType    = 'FollowC2S'
            } elseif ($QosIpPrecedence) {
                $Object.QosType    = 'IpPrecedence'
                $Object.QosMarking = [HelperXml]::parseCandidateConfigXml($entry.marking.'ip-precedence',$false)
            } elseif ($QosIpDscp) {
                $Object.QosType    = 'IpDscp'
                $Object.QosMarking = [HelperXml]::parseCandidateConfigXml($entry.marking.'ip-dscp',$false)
            }

        }

        if ($Name) {
            $ReturnObject = $ReturnObject | Where-Object { $_.Name -eq $Name }
        }

        $ReturnObject
    }
}