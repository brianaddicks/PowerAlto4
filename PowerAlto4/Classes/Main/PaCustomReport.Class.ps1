######################################## Enums #######################################
# Short Database Names
Enum ShortDatabase {
    trsum = 1
}

class PaCustomReport {
    [string]$Name
    [string]$Description
    [string]$Database
    [string]$FirstColumn
    [string[]]$Members
    [string]$TimeFrame
    [int]$EntriesShown
    [int]$Groups

    ###################################### Methods #######################################
    # invokeReportGetQuery
    [Xml] ToXml() {
        [xml]$Doc = New-Object System.Xml.XmlDocument
        $root = $Doc.CreateNode("element","reports",$null)
        
        # Start Entry Node
        $EntryNode = $Doc.CreateNode("element","entry",$null)
        $EntryNode.SetAttribute("name",$this.Name)

        # Start Type Node
        $TypeNode = $Doc.CreateNode("element","type",$null)

        # Start DatabaseNode
        $DatabaseShortName = $this.TranslateDatabaseName($this.Database,"short")
        $DatabaseNode = $Doc.CreateNode("element",$DatabaseShortName,$null)
        
        # aggregate-by propert (FirstColumn)
        $FirstColumnNode = $Doc.CreateNode("element",'aggregate-by',$null)
        $FirstColumnMemberNode = $Doc.CreateNode("element",'member',$null)
        $FirstColumnMemberNode.InnerText = $this.FirstColumn
        $FirstColumnNode.AppendChild($FirstColumnMemberNode)
        $DatabaseNode.AppendChild($FirstColumnNode)

        # value members
        $ValuesNode = $Doc.CreateNode("element",'values',$null)
        foreach ($m in $this.Members) {
            $MemberNode = $Doc.CreateNode("element",'member',$null)
            $MemberNode.InnerText = $m
            $ValuesNode.AppendChild($MemberNode)
        }
        $DatabaseNode.AppendChild($ValuesNode)
        
        # add Database to type
        $TypeNode.AppendChild($DatabaseNode)

        # Add Type to Entry Node
        $EntryNode.AppendChild($TypeNode)

        # Create/Add TimeFrame to Entry
        $TimeFrameNode = $Doc.CreateNode("element",'period',$null)
        $TimeFrameNode.InnerText = $this.TimeFrame
        $EntryNode.AppendChild($TimeFrameNode)

        # Create/Add EntriesShown to Entry
        $EntriesShownNode = $Doc.CreateNode("element",'topn',$null)
        $EntriesShownNode.InnerText = $this.EntriesShown
        $EntryNode.AppendChild($EntriesShownNode)

        # Create/Add Groups to Entry
        $GroupsNode = $Doc.CreateNode("element",'topm',$null)
        $GroupsNode.InnerText = $this.Groups
        $EntryNode.AppendChild($GroupsNode)

        # Create/Add Description to Entry
        $GroupsNode = $Doc.CreateNode("element",'description',$null)
        $GroupsNode.InnerText = $this.Description
        $EntryNode.AppendChild($GroupsNode)

        # Append Entry to Root and Root to Doc
        $root.AppendChild($EntryNode)
        $Doc.AppendChild($root)

        return $Doc
    }

    # Translate Database strings
    [string] TranslateDatabaseName([string]$Name,[string]$DesiredType) {
        $DatabaseTranslations = @{}
        $DatabaseTranslations.trsum = "Traffic Summary"

        $TranslatedName = $null
        if (($DatabaseTranslations.Keys -contains $Name) -and ($DesiredType -eq "Friendly")) {
            $TranslatedName = $DatabaseTranslations.$Name
        } elseif (($DatabaseTranslations.Values -contains $Name) -and ($DesiredType -eq "Short")) {
            $TranslatedName = $DatabaseTranslations.Keys | Where-Object { $DatabaseTranslations["$_"] -eq $Name }
        } else {
            Throw "Invalid Database Name: $Name"
        }

        return $TranslatedName
    }

    ##################################### Initiators #####################################
    # Initiator
    PaCustomReport([string]$Name) {
        $this.Name = $Name
    }
}