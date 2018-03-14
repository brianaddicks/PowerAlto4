# Invoke-PaApiConfig

## Synopsis

Invokes a Palo Alto Config Api.

## Syntax


```powershell
Invoke-PaApiConfig [-Action] <String> [-XPath] <String> 
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

### -Action

Action to use for the Api Config Call (get, set, rename currently supported)

```asciidoc
Type: String
Parameter Sets: All
Aliases: 

Required: true
Position: 1
Default value: get
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


