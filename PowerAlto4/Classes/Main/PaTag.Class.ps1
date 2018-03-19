class PaTag {
    [string]$Name
    [string]$Color
    [string]$Comments

    ###################################### Methods #######################################
    # invokeReportGetQuery
    [Xml] ToXml() {
        [xml]$Doc = New-Object System.Xml.XmlDocument
        $root = $Doc.CreateNode("element","tag",$null)
        
        # Start Entry Node
        $EntryNode = $Doc.CreateNode("element","entry",$null)
        $EntryNode.SetAttribute("name",$this.Name)

        # color
        $PropertyNode = $Doc.CreateNode("element",'color',$null)
        $PropertyNode.InnerText = $this.Color
        $EntryNode.AppendChild($PropertyNode)

        # comments
        $PropertyNode = $Doc.CreateNode("element",'comments',$null)
        $PropertyNode.InnerText = $this.Comments
        $EntryNode.AppendChild($PropertyNode)

        # Append Entry to Root and Root to Doc
        $root.AppendChild($EntryNode)
        $Doc.AppendChild($root)

        return $Doc
    }

    ##################################### Initiators #####################################
    # Initiator
    PaAddress([string]$Name) {
        $this.Name = $Name
    }
}