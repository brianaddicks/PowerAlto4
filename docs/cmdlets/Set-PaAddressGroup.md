# Set-PaAddressGroup

## Synopsis

Creates/Configures an address object on a Palo Alto device.

## Syntax

### name-filter

```powershell
Set-PaAddressGroup [-Name] <String> -Filter <String> [-Description <String>] [-Tag <String[]>] [-WhatIf] [-Confirm] 
```

### name-member

```powershell
Set-PaAddressGroup [-Name] <String> -Member <String> [-Description <String>] [-Tag <String[]>] [-WhatIf] [-Confirm] 
```

### object-filter

```powershell
Set-PaAddressGroup [-PaAddressGroup] <PaAddressGroup> [-Filter <String>] [-Description <String>] [-Tag <String[]>] [-WhatIf] [-Confirm] 
```

### object-member

```powershell
Set-PaAddressGroup [-PaAddressGroup] <PaAddressGroup> [-Member <String>] [-Description <String>] [-Tag <String[]>] [-WhatIf] [-Confirm] 
```

## Description

Creates/Configures an address object on a Palo Alto device.

## Examples

### Example 1

```
PS c:\> 
```













## Parameters

### -Name


```asciidoc
Type: String
Parameter Sets: name-filter, name-member
Aliases: 

Required: true
Position: 1
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -PaAddressGroup


```asciidoc
Type: PaAddressGroup
Parameter Sets: object-filter, object-member
Aliases: 

Required: true
Position: 1
Default value: 
Accept pipeline input: true (ByValue)
Accept wildcard characters: false
```
### -Filter


```asciidoc
Type: String
Parameter Sets: name-filter, object-filter
Aliases: 

Required: true
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -Member


```asciidoc
Type: String
Parameter Sets: name-member, object-member
Aliases: 

Required: true
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -Description


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
### -Tag


```asciidoc
Type: String[]
Parameter Sets: All
Aliases: 

Required: false
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


