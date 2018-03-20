class PaSecurityPolicy {
    # General
    [int]$Number
    [string]$Name
    [string]$RuleType = 'universal'
    [string]$Description
    [string[]]$Tags

    # Source
    [string[]]$SourceZone
    [string[]]$SourceAddress = 'any'

    # User
    [string[]]$SourceUser = 'any'
    [string[]]$HipProfile = 'any'

    # Destination
    [string[]]$DestinationZone
    [string[]]$DestinationAddress = 'any'

    # Application
    [string[]]$Application = 'any'

    # Service/Url Category
    [string[]]$Service = 'application-default'
    [string[]]$UrlCategory = 'any'

    # Actions
    ## Action Setting
    [string]$Action = 'allow'
    [bool]$SendIcmpUnreachable
    
    ## Profile Setting
    [string]$ProfileType
    [string]$GroupProfile
    [string]$Antivirus
    [string]$VulnerabilityProtection
    [string]$AntiSpyware
    [string]$UrlFiltering
    [string]$FileBlocking
    [string]$DataFiltering
    [string]$WildFireAnalysis

    ## Log Setting
    [bool]$LogAtSessionStart
    [bool]$LogAtSessionEnd
    [string]$LogForwarding

    ## Other Settings
    [string]$Schedule
    [string]$QosType
    [string]$QosMarking
    [bool]$Dsri

    ###################################### Methods #######################################
    # ToXml
    [Xml] ToXml() {
        [xml]$Doc = New-Object System.Xml.XmlDocument
        $root = $Doc.CreateNode("element","address",$null)
        
        # Start Entry Node
        $EntryNode = $Doc.CreateNode("element","entry",$null)
        $EntryNode.SetAttribute("name",$this.Name)

        # Start Type Node with Value
        $TypeNode = $Doc.CreateNode("element",$this.Type,$null)
        $TypeNode.InnerText = $this.Value
        $EntryNode.AppendChild($TypeNode)

        if ($this.Tags) {
            # Tag Members
            $MembersNode = $Doc.CreateNode("element",'tag',$null)
            foreach ($member in $this.Tags) {
                $MemberNode = $Doc.CreateNode("element",'member',$null)
                $MemberNode.InnerText = $member
                $MembersNode.AppendChild($MemberNode)
            }
            $EntryNode.AppendChild($MembersNode)
        }

        if ($this.Description) {
            # Description
            $DescriptionNode = $Doc.CreateNode("element","description",$null)
            $DescriptionNode.InnerText = $this.Description
            $EntryNode.AppendChild($DescriptionNode)
        }

        # Append Entry to Root and Root to Doc
        $root.AppendChild($EntryNode)
        $Doc.AppendChild($root)

        return $Doc
    }

    ##################################### Initiators #####################################
    # Initiator
    PaSecurityPolicy([string]$Name) {
        $this.Name = $Name
    }
}