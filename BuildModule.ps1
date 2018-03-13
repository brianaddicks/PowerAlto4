[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$ReleaseNotes,

    [Parameter(Mandatory=$False)]
    [switch]$IncrementVersion,

    [Parameter(Mandatory=$False)]
    [switch]$PublishToPsGallery
)

###############################################################################
# Create Manifest

# PsGallery requires: module name, version, description, and author
$ProjectRoot     = Split-Path -parent $MyInvocation.MyCommand.Definition 
$ModuleName      = Get-Location | Split-Path -Leaf

# Outputs
$OutputDirectory = $ProjectRoot     + '/' + $ModuleName
$ManifestFile    = $OutputDirectory + '/' + $ModuleName + '.psd1'
$ModuleFile      = $OutputDirectory + '/' + $ModuleName + '.psm1'
$ClassDirectory  = $OutputDirectory + '/Classes'

###############################################################################
# Run PSSA
$ExcludedRules = @()
$ExcludedRules += 'PSAvoidGlobalVars'

# Load Classes into memory
# PowerShell Core and/or the MacOS File System Drive don't order these in alpha
# order.  Loading them first keeps PSSA from throwing dependency errors.

$ClassFiles = Get-ChildItem -Path $ClassDirectory -Recurse -File | Sort-Object
foreach ($class in $ClassFiles) {
    . $class.FullName
}

# Run PSSA
Invoke-ScriptAnalyzer -Path $OutputDirectory  -Recurse -Settings PSGallery -ExcludeRule $ExcludedRules



$Description = "@
PowerAlto provides an interface to the Palo Alto Firewall API.

https://github.com/brianaddicks/PowerAlto4
@"

if (Test-Path $ManifestFile) {
    $UpdateParams                    = @{}
    $UpdateParams.Path               = $ManifestFile
    $UpdateParams.FunctionsToExport  = '*'

    if ($ReleaseNotes) {
        $UpdateParams.ReleaseNotes = $ReleaseNotes
    }

    if ($IncrementVersion) {
        $CurrentVersion = (Test-ModuleManifest $ManifestFile).Version
        $NewVersion = "{0}.{1}.{2}" -f $CurrentVersion.Major, $CurrentVersion.Minor, ($CurrentVersion.Build + 1)
        $UpdateParams.ModuleVersion = $NewVersion
    }
    
    if ($ReleaseNotes -or $IncrementVersion) {
        Update-ModuleManifest @UpdateParams
    }
    
} else {
    $ManifestParams = @{ Path               = $ManifestFile
                        ModuleVersion      = '0.0.1'
                        Author             = 'Brian Addicks'
                        RootModule         = 'PowerAlto4.psm1'
                        CompanyName        = 'Lockstep Technology Group'
                        Description        = $Description
                        LicenseUri         = 'https://raw.githubusercontent.com/brianaddicks/PowerAlto4/master/LICENSE'
                        ProjectUri         = 'https://github.com/brianaddicks/PowerAlto4'
                        CmdletsToExport    = '*'
                        FunctionsToExport  = '*'
                        PowerShellVersion  = '5.0' }

    New-ModuleManifest @ManifestParams
}


# Create Documentation

# Add new docs to mkdocs file, didn't have much luck with any of the powershell yaml modules out there, so here's the cheap way to do it.

$MkdocsTheme = "readthedocs"
$MkdocsSiteName = "$ModuleName Docs"
$Pages = @{}
$Pages.Home = 'index.md'
$Pages.Cmdlets = @{}

# Import Our Module
$Remove  = Remove-Module $ModuleName
$Import  = Import-Module $ManifestFile
$Cmdlets = Get-Command -Module $ModuleName

foreach ($Cmdlet in $Cmdlets) {
    $CmdletName = $Cmdlet.Name
    ./CreateHelpFile.ps1 -Cmdlet $CmdletName -Destination "./docs/cmdlets/$CmdletName.md"
    $Pages.Cmdlets.$CmdletName = "cmdlets/$CmdletName.md"
}

# Output
$MkdocsOutput = @()
$MkdocsOutput += "site_name: " + $MkdocsSiteName
$MkdocsOutput += "theme: " + $MkdocsTheme
$MkdocsOutput += "pages:"

function ConvertHashToYaml ($Value,$Indent = 1) {
    [CmdletBinding()]
    $ReturnObject = @()
    
    # Get Indententation
    $TabSpace = ""
    for ($i = 0;$i -lt $Indent;$i++) {
        $TabSpace += "  "
    }

    switch ($Value.GetType().Name) {
        'hashtable' {
            foreach ($entry in $Value.GetEnumerator()) {
                $NewLine = $TabSpace + "- " + $entry.Key + ":"
                if ($entry.Value.GetType().Name -eq "string") {
                    Write-Verbose "string"
                    $ReturnObject += $TabSpace + "- " + $entry.Key + ": " + $entry.Value
                } else {
                    $ReturnObject += $TabSpace + "- " + $entry.Key + ":"
                    $ReturnObject += ConvertHashToYaml $entry.Value -Indent ($Indent + 1)
                }
                
            }
        }
        'string' {
            return $Value
        }
    }
    return $ReturnObject
}

$MkdocsOutput += ConvertHashToYaml $Pages

$MkdocsOutput | Out-File ./mkdocs.yml

##############################################################################
# PublishToPsGallery

#if ($PublishToPsGallery -and ($PSVersionTable.PSEdition -ne "Core")) {
if ($PublishToPsGallery) {
    Publish-Module -Path (Resolve-Path "./$ModuleName/") -NuGetApiKey $global:nugetapikey
}
