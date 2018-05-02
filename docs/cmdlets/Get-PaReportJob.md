# Get-PaReportJob

## Synopsis

Gets Report Job status from Palo Alto Device.

## Syntax

### singlejob (Default)

```powershell
Get-PaReportJob [-JobId] <Int32> [-Wait] [-ShowProgress] 
```

### alljobs

```powershell
Get-PaReportJob [[-JobId] <Int32>] 
```

## Description

Gets Report Job status from Palo Alto Device.

## Examples

## Parameters

### -JobId


```asciidoc
Type: Int32
Parameter Sets: All
Aliases: 

Required: true
Position: 1
Default value: 0
Accept pipeline input: false
Accept wildcard characters: false
```
### -Wait


```asciidoc
Type: SwitchParameter
Parameter Sets: singlejob
Aliases: 

Required: false
Position: named
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -ShowProgress


```asciidoc
Type: SwitchParameter
Parameter Sets: singlejob
Aliases: 

Required: false
Position: named
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
