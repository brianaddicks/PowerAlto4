class PaTag {
    [string]$Name
    [string]$Color
    [string]$Comments

    ###################################### Methods #######################################

    ##########################
    # ToXml
    [Xml] ToXml() {
        [xml]$Doc = New-Object System.Xml.XmlDocument
        $root = $Doc.CreateNode("element","tag",$null)
        
        # Start Entry Node
        $EntryNode = $Doc.CreateNode("element","entry",$null)
        $EntryNode.SetAttribute("name",$this.Name)

        # color
        $PropertyNode = $Doc.CreateNode("element",'color',$null)
        $PropertyNode.InnerText = [PaTag]::($this.Color,'Unfriendly')
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

    ##########################
    # GetColorName
    static [string]GetColorName([string]$Color,[string]$ReturnedType) {
        $Mapping         = @{}
        $Mapping.color1  = 'Red'
        $Mapping.color2  = 'Green'
        $Mapping.color3  = 'Blue'
        $Mapping.color4  = 'Yellow'
        $Mapping.color5  = 'Copper'
        $Mapping.color6  = 'Orange'
        $Mapping.color7  = 'Purple'
        $Mapping.color8  = 'Gray'
        $Mapping.color9  = 'Light Green'
        $Mapping.color10 = 'Cyan'
        $Mapping.color11 = 'Light Gray'
        $Mapping.color12 = 'Blue Gray'
        $Mapping.color13 = 'Lime'
        $Mapping.color14 = 'Black'
        $Mapping.color15 = 'Gold'
        $Mapping.color16 = 'Brown'
        $Mapping.color17 = 'Green'

        $ReturnedName   = $null
        $FriendlyName   = $null
        $UnfriendlyName = $null
        Write-Verbose "color: $Color"

        if (($Color -match "color\d{1,2}") -and ($Mapping.Keys -contains $Color)) {
            $FriendlyName =  $Mapping.$Color
        } elseif ($Mapping.GetEnumerator() | Where-Object { $_.Value -eq $Color}) {
            $UnfriendlyName = ($Mapping.GetEnumerator() | Where-Object { $_.Value -eq $Color}).Name
        } else {
            Throw "Invalid color specified: $Color"
        }

        switch ($ReturnedType) {
            'Friendly' {
                $ReturnedName = $FriendlyName
            }
            'UnFriendly' {
                $ReturnedName = $UnfriendlyName
            }
        }

        return $ReturnedName
    }


    ##################################### Initiators #####################################
    # Initiator
    PaTag([string]$Name) {
        $this.Name = $Name
    }
    
    # Initiator with color
    PaTag([string]$Name,[string]$Color) {
        $this.Name  = $Name
        $this.Color = [PaTag]::GetColorName($Color,"Friendly")
    }
}