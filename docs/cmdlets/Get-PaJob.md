# Get-PaJob

## Synopsis

Gets job status from Palo Alto Device.

## Syntax

### singlejob

```powershell
Get-PaJob [-JobId] <Int32> [-Wait] [-ShowProgress] [-ReportJob] 
```

### alljobs

```powershell
Get-PaJob [[-JobId] <Int32>] 
```

### latest

```powershell
Get-PaJob [-Latest] [-Wait] [-ShowProgress] 
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
### -ReportJob


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
