function Set-PaTargetDeviceGroup {
	<#
	.SYNOPSIS
		Changes target Device Group for current session.
		
	.DESCRIPTION
		Changes target Device Group for current session.

    .EXAMPLE
        Set-PaTargetDeviceGroup -Name "remote-sites"

        Changes context in panorama to the "remote-sites" Device Group
		
	.PARAMETER Name
		Name of the desired Device Group.
	#>
	[CmdletBinding()]

	Param (
		[Parameter(Mandatory=$True,Position=0)]
        [string]$Name
	)

    BEGIN {
    }

    PROCESS {
        if ($global:PaDeviceObject.Connected) {
            if ($global:PaDeviceObject.Model -ne 'Panorama') {
                Throw "$($global:PaDeviceObject.Hostname) is not a Panorama device"
            }
            $global:PaDeviceObject.TargetDeviceGroup = $Name
        } else {
            Throw "No Palo Alto Device connected.  Use Get-PaDevice to initiate a connection."
        }
    }
}