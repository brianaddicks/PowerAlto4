[CmdletBinding()]
Param (
    [Parameter(Mandatory=$True,Position=0)]
    [string]$Cmdlet,

    [Parameter(Mandatory=$True,Position=1)]
    [string]$Destination
)

$CmdletInfo = Get-Command $Cmdlet
$HelpInfo   = Get-Help $Cmdlet
$Output = @()

# Header
$Output += "# $($CmdletInfo.Name)"
$Output += ""

# Synopsis
$Output += "## Synopsis"
$Output += ""
$Output += $Helpinfo.Synopsis
$Output += ""

# Syntax
$Output += "## Syntax"
$Output += ""

$i = 0
foreach ($Set in $CmdletInfo.ParameterSets) {
    # need to limit line lenght to 90 char
    $SetName = $Set.Name
    if ($Set.IsDefault) {
        $SetName += " (Default)"
    }
    if ($SetName -notmatch "__AllParameterSets") {
        $Output += "### $SetName"
    }
    $Output += ""

    $Syntax = $HelpInfo.syntax.syntaxItem[$i].parameter
    $SyntaxString = ""
    $SyntaxString += $CmdletInfo.Name + " "
    
    foreach ($Parameter in $Syntax) {
        $ParamString = ""

        if ($Parameter.parameterValue) {
            $ParameterValue = "<" + $Parameter.parameterValue + ">"
        } else {
            $ParameterValue = $null
        }
        Write-Verbose "ParameterValue: $ParameterValue"

        if ($Parameter.position -eq 'named') {
            $ParameterName = "-" + $Parameter.name
        } else {
            $ParameterName = "[-" + $Parameter.name + "]"
        }

        if ($Parameter.required -eq $true) {
            Write-Verbose "Is Required"
            $ParameterString = $ParameterName
            if ($ParameterValue.Length -gt 0) {
                Write-Verbose "ParameterValue present"
                $ParameterString += " " + $ParameterValue
            }
        } else {
            Write-Verbose "Is Not Required"
            $ParameterString = "[" + $ParameterName
            if ($ParameterValue) {
                $ParameterString += " " + $ParameterValue
            }
            $ParameterString += "]"
        }
        $ParameterString += " "
        
        $SyntaxString += $ParameterString
    }

    $Output += '```powershell'
    $Output += $SyntaxString
    $Output += '```'
    $Output += ''

    $i++
}

# Description
$Output += "## Description"
$Output += ''
$Output += $HelpInfo.description.text
$Output += ''

# Examples
$Output += "## Examples"
$Output += ''
$Examples = $HelpInfo.examples.example
$e = 1
foreach ($Example in $Examples) {
    $ExampleString = @()
    $ExampleString += "### Example $e"
    $ExampleString += ""
    $ExampleString += '```'
    $ExampleString += "PS c:\> $($Example.Code)"
    $ExampleString += '```'
    $ExampleString += ""
    $ExampleString += $Example.remarks
    $ExampleString += ""

    $Output += $ExampleString
    $e++
}

# Parameters
$Output += "## Parameters"
$Output += ''

$ParameterSetCount = $Cmdletinfo.ParameterSets.Count

$Parameters = $HelpInfo.parameters.parameter
foreach ($Parameter in $Parameters) {
    $ParameterString = @()
    
    # Name
    $ParameterString += "### -$($Parameter.Name)"
    $ParameterString += ""
    
    # Description
    $ParameterString += $Parameter.description.text
    $ParameterString += ""

    # ParameterSet Lookup
    $ParameterLookup = $CmdletInfo.ParameterSets | Where-Object { $_.Parameters.name -contains $Parameter.Name }
    if ($ParameterLookup.Count -eq $ParameterSetCount) {
        $ParameterSetString = "All"
    } else {
        $ParameterSetString = $ParameterLookup.name -join ", "
    }

    # Cmdlet Lookup
    $CmdletLookup = $CmdletInfo.Parameters."$($Parameter.Name)"
    $Aliases = $CmdletLookup.Aliases -join ", "


    # Properties
    $ParameterString += '```asciidoc'
    $ParameterString += "Type: " + $Parameter.type.name
    $ParameterString += "Parameter Sets: " + $ParameterSetString
    $ParameterString += "Aliases: " + $Aliases
    $ParameterString += ""
    $ParameterString += "Required: " + $Parameter.required
    $ParameterString += "Position: " + $Parameter.position
    $ParameterString += "Default value: " + $Parameter.defaultValue
    $ParameterString += "Accept pipeline input: " + $Parameter.pipelineInput
    $ParameterString += "Accept wildcard characters: " + $Parameter.globbing
    $ParameterString += '```'

    $Output += $ParameterString
}

# Output File
$global:OutTest = $Output
$Output | Out-File $Destination -Encoding ascii