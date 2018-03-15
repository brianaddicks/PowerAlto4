# Set-PaCustomReport

## Synopsis

Creates/Configures a custom report on a Palo Alto device.

## Syntax

### summary

```powershell
Set-PaCustomReport [-Name] <String> [-Vsys <String>] -SummaryDatabase <String> -TimeFrame <String> [-EntriesShown <Int32>] [-Groups <Int32>] -Columns <String[]> [-WhatIf] [-Confirm] 
```

### detailed

```powershell
Set-PaCustomReport [-Name] <String> [-Vsys <String>] -DetailedLog <String> -TimeFrame <String> [-EntriesShown <Int32>] [-Groups <Int32>] -Columns <String[]> [-WhatIf] [-Confirm] 
```

## Description

Creates/Configures a custom report on a Palo Alto device.

## Examples

### Example 1

```
PS c:\> 
```













## Parameters

### -Name


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
### -Vsys


```asciidoc
Type: String
Parameter Sets: All
Aliases: 

Required: false
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -SummaryDatabase


```asciidoc
Type: String
Parameter Sets: summary
Aliases: 

Required: true
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -DetailedLog


```asciidoc
Type: String
Parameter Sets: detailed
Aliases: 

Required: true
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -TimeFrame


```asciidoc
Type: String
Parameter Sets: All
Aliases: 

Required: true
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -EntriesShown


```asciidoc
Type: Int32
Parameter Sets: All
Aliases: 

Required: false
Position: named
Default value: 10
Accept pipeline input: false
Accept wildcard characters: false
```
### -Groups


```asciidoc
Type: Int32
Parameter Sets: All
Aliases: 

Required: false
Position: named
Default value: 10
Accept pipeline input: false
Accept wildcard characters: false
```
### -Columns


```asciidoc
Type: String[]
Parameter Sets: All
Aliases: 

Required: true
Position: named
Default value: 
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


