# Invoke-PaApiConfig

## Synopsis

Invokes a Palo Alto Config Api.

## Syntax

### get (Default)

```powershell
Invoke-PaApiConfig [-Get] [-XPath] <String> 
```

### edit

```powershell
Invoke-PaApiConfig [-Edit] [-Element] <String> [-XPath] <String> 
```

### set

```powershell
Invoke-PaApiConfig [-Set] [-Element] <String> [-XPath] <String> 
```

## Description

Invokes a Palo Alto Config Api.

## Examples

### Example 1

```
PS c:\> Invoke-PaApiConfig -Action "get" -XPath "/config/devices/entry[@name='localhost.localdomain']/network/interface"
```


Returns interface configuration for the currently connected Palo Alto Device.










## Parameters

### -Get

get parameters

```asciidoc
Type: SwitchParameter
Parameter Sets: get
Aliases: 

Required: true
Position: 1
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -Edit

edit parameters

```asciidoc
Type: SwitchParameter
Parameter Sets: edit
Aliases: 

Required: true
Position: 1
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -Set

set parameters

```asciidoc
Type: SwitchParameter
Parameter Sets: set
Aliases: 

Required: true
Position: 1
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -Element


```asciidoc
Type: String
Parameter Sets: edit, set
Aliases: 

Required: true
Position: 2
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -XPath

XPath of desired configuration.

```asciidoc
Type: String
Parameter Sets: All
Aliases: 

Required: true
Position: 2
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```


