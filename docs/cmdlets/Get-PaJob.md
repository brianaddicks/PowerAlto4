# Get-PaJob

## Synopsis

Gets job status from Palo Alto Device.

## Syntax

### singlejob

```powershell
Get-PaJob [-JobId] <Int32> [-Wait] [-ShowProgress] [-WhatIf] [-Confirm] 
```

### alljobs

```powershell
Get-PaJob [[-JobId] <Int32>] [-WhatIf] [-Confirm] 
```

### latest

```powershell
Get-PaJob [-Latest] [-Wait] [-ShowProgress] [-WhatIf] [-Confirm] 
```

## Description

Gets job status from Palo Alto Device.

## Examples

## Parameters

### -JobId


```asciidoc
Type: Int32
Parameter Sets: singlejob, alljobs
Aliases: 

Required: true
Position: 1
Default value: 0
Accept pipeline input: false
Accept wildcard characters: false
```
### -Latest


```asciidoc
Type: SwitchParameter
Parameter Sets: latest
Aliases: 

Required: true
Position: 1
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -Wait


```asciidoc
Type: SwitchParameter
Parameter Sets: singlejob, latest
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
Parameter Sets: singlejob, latest
Aliases: 

Required: false
Position: named
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -WhatIf


```asciidoc
Type: SwitchParameter
Parameter Sets: All
Aliases: wi

Required: false
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -Confirm


```asciidoc
Type: SwitchParameter
Parameter Sets: All
Aliases: cf

Required: false
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
