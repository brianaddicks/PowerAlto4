# Set-PaAddress

## Synopsis

Creates/Configures an address object on a Palo Alto device.

## Syntax

### name

```powershell
Set-PaAddress [-Name] <String> -Type <String> -Value <String> [-Description <String>] [-Tag <String[]>] [-WhatIf] [-Confirm] 
```

### paaddress

```powershell
Set-PaAddress [-PaAddress] <PaAddress> [-Type <String>] [-Value <String>] [-Description <String>] [-Tag <String[]>] [-WhatIf] [-Confirm] 
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
Parameter Sets: name
Aliases: 

Required: true
Position: 1
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -PaAddress


```asciidoc
Type: PaAddress
Parameter Sets: paaddress
Aliases: 

Required: true
Position: 1
Default value: 
Accept pipeline input: true (ByValue)
Accept wildcard characters: false
```
### -Type


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
### -Value


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


