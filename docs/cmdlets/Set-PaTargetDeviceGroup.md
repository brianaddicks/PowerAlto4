# Set-PaTargetDeviceGroup

## Synopsis

Changes target Device Group for current session.

## Syntax


```powershell
Set-PaTargetDeviceGroup [-Name] <String> 
```

## Description

Changes target Device Group for current session.

## Examples

### Example 1

```
PS c:\> Set-PaTargetDeviceGroup -Name "remote-sites"
```


Changes context in panorama to the "remote-sites" Device Group










## Parameters

### -Name

Name of the desired Device Group.

```asciidoc
Type: String
Parameter Sets: All
Aliases: 

Required: true
Position: 1
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```


