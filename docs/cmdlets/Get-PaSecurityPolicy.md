# Get-PaSecurityPolicy

## Synopsis

Retrieve Security Policies from Palo Alto device.

## Syntax

### postrulebase

```powershell
Get-PaSecurityPolicy [[-Name] <String>] -PostRulebase 
```

### prerulebase

```powershell
Get-PaSecurityPolicy [[-Name] <String>] -PreRulebase 
```

### rulebase

```powershell
Get-PaSecurityPolicy [[-Name] <String>] 
```

## Description

Retrieve Security Policies from Palo Alto device.

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

Required: false
Position: 1
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -PreRulebase


```asciidoc
Type: SwitchParameter
Parameter Sets: prerulebase
Aliases: 

Required: true
Position: named
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -PostRulebase


```asciidoc
Type: SwitchParameter
Parameter Sets: postrulebase
Aliases: 

Required: true
Position: named
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```


