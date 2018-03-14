######################################## Enums #######################################
# Short Database Names
Enum ShortDatabase {
    trsum = 1
}

class PaCustomReport {
    [string]$Name
    [string]$Database
    [string]$FirstColumn
    [string[]]$Members
    [string]$Period
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
        $DatabaseShortName = $this.TranslateDatabaseName($this.Database)
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


        $root.AppendChild($EntryNode)
        $Doc.AppendChild($root)

        return $Doc
    }

    # Translate Database strings
    [string] TranslateDatabaseName([string]$Name) {
        $DatabaseTranslations = @{}
        $DatabaseTranslations.trsum = "Traffic Summary"

        $TranslatedName = $null
        if ($DatabaseTranslations.Keys -contains $Name) {
            $TranslatedName = $DatabaseTranslations.$Name
        } elseif ($DatabaseTranslations.Values -contains $Name) {
            $TranslatedName = $DatabaseTranslations.Keys | Where-Object { $DatabaseTranslations["$_"] -eq $Name }
        } else {
            Throw "Invalid Database Name: $Name"
        }

        return $TranslatedName
    }

    ##################################### Initiators #####################################
    # Initiator with apikey
    PaCustomReport([string]$Name,[ShortDatabase]$Database) {
        $this.Name = $Name
        $this.Database = $this.TranslateDatabaseName($Database)
    }
}

<#
<reports>
<entry name="ltg_overall-traffic">
<type>
<trsum>
<aggregate-by>
<member>quarter-hour-of-receive_time</member>
</aggregate-by>
<values>
<member>bytes</member>
<member>sessions</member>
</values>
</trsum>
</type>
<period>last-24-hrs</period>
<topn>100</topn>
<topm>10</topm>
<caption>ltg_overall-traffic</caption>
</entry>
</reports>
#>