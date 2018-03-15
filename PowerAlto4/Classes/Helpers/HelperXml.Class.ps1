class HelperXml {
    static [string] parseCandidateConfigXml ($XmlNode,[bool]$ReturnNodeName = $false) {
        # Nodes we want to ignore
        # This is to ignore the data you get about changes in a candidate config
        $UnWantedNodes = @()
        $UnWantedNodes += 'admin'
        $UnWantedNodes += 'dirtyId'
        $UnWantedNodes += 'time'
        
        $ReturnValue = $null
        if ($XmlNode.'#text') {
            # '#text' node only shows up for Candidate configurations
            $ReturnValue = $XmlNode.'#text'
        } else {
            if ($ReturnNodeName) {
                $Nodes = $XmlNode | Get-Member -MemberType Property
                $Node = $Nodes | Where-Object { $UnwantedNodes -notcontains $_.Name }
                $ReturnValue = $Node.Name
            } else {
                $ReturnValue = $XmlNode
            }
        }

        return $ReturnValue
    }

    static [array] SplitXml ([xml]$Content) {
        # String Writer and XML Writer objects to write XML to string
        $StringWriter = New-Object System.IO.StringWriter 
        $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter 
        
        # Default = None, change Formatting to Indented
        $xmlWriter.Formatting = "indented" 
        
        # Gets or sets how many IndentChars to write for each level in 
        # the hierarchy when Formatting is set to Formatting.Indented
        $Content.WriteContentTo($XmlWriter) 
        $XmlWriter.Flush()
        $StringWriter.Flush() 
        $ReturnObject = $StringWriter.ToString() -split '[\r\n]'

        return $ReturnObject
    }
}