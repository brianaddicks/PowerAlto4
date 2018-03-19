# Set-PaAddress

## Synopsis

Creates/Configures an address object on a Palo Alto device.

## Syntax

### ip-netmask

```powershell
Set-PaAddress [-Name] <String> -IpNetmask <String> [-Description <String>] [-Tags <Array>] [-WhatIf] [-Confirm] 
```

### ip-range

```powershell
Set-PaAddress [-Name] <String> -IpRange <String> [-Description <String>] [-Tags <Array>] [-WhatIf] [-Confirm] 
```

### fqdn

```powershell
Set-PaAddress [-Name] <String> -Fqdn <String> [-Description <String>] [-Tags <Array>] [-WhatIf] [-Confirm] 
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
Parameter Sets: All
Aliases: 

Required: true
Position: 1
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -IpNetmask


```asciidoc
Type: String
Parameter Sets: ip-netmask
Aliases: 

Required: true
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -IpRange


```asciidoc
Type: String
Parameter Sets: ip-range
Aliases: 

Required: true
Position: named
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -Fqdn


```asciidoc
Type: String
Parameter Sets: fqdn
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
### -Tags


```asciidoc
Type: Array
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


