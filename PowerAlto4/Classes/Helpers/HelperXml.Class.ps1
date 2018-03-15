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
}