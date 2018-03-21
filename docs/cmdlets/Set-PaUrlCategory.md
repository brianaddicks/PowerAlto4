# Set-PaUrlCategory

## Synopsis

Creates/Configures an Custom Url Category on a Palo Alto device.

## Syntax

### paobject

```powershell
Set-PaUrlCategory [-PaUrlCategory] <PaUrlCategory> [-WhatIf] [-Confirm] 
```

### replace

```powershell
Set-PaUrlCategory [-Name] <String> [-Members] <String[]> -ReplaceMembers [-WhatIf] [-Confirm] 
```

### manual

```powershell
Set-PaUrlCategory [-Name] <String> [[-Members] <String[]>] [[-Description] <String>] [-WhatIf] [-Confirm] 
```

## Description

Creates/Configures an Custom Url Category on a Palo Alto device.

## Examples

### Example 1

```
PS c:\> 
```













## Parameters

### -PaUrlCategory

paobject

```asciidoc
Type: PaUrlCategory
Parameter Sets: paobject
Aliases: 

Required: true
Position: 1
Default value: 
Accept pipeline input: true (ByValue)
Accept wildcard characters: false
```
### -Name


```asciidoc
Type: String
Parameter Sets: replace, manual
Aliases: 

Required: true
Position: 1
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -Members


```asciidoc
Type: String[]
Parameter Sets: replace, manual
Aliases: 

Required: true
Position: 2
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -Description


```asciidoc
Type: String
Parameter Sets: manual
Aliases: 

Required: false
Position: 3
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -ReplaceMembers


```asciidoc
Type: SwitchParameter
Parameter Sets: replace
Aliases: 

Required: true
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


