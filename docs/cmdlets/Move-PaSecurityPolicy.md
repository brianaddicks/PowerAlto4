# Move-PaSecurityPolicy

## Synopsis


Move-PaSecurityPolicy [-Name] <string> -Bottom [-WhatIf] [-Confirm] [<CommonParameters>]

Move-PaSecurityPolicy [-Name] <string> -Top [-WhatIf] [-Confirm] [<CommonParameters>]

Move-PaSecurityPolicy [-Name] <string> -After <string> [-WhatIf] [-Confirm] [<CommonParameters>]

Move-PaSecurityPolicy [-Name] <string> -Before <string> [-WhatIf] [-Confirm] [<CommonParameters>]

Move-PaSecurityPolicy [-PaSecurityPolicy] <PaSecurityPolicy> -Bottom [-WhatIf] [-Confirm] [<CommonParameters>]

Move-PaSecurityPolicy [-PaSecurityPolicy] <PaSecurityPolicy> -Top [-WhatIf] [-Confirm] [<CommonParameters>]

Move-PaSecurityPolicy [-PaSecurityPolicy] <PaSecurityPolicy> -After <string> [-WhatIf] [-Confirm] [<CommonParameters>]

Move-PaSecurityPolicy [-PaSecurityPolicy] <PaSecurityPolicy> -Before <string> [-WhatIf] [-Confirm] [<CommonParameters>]


## Syntax

### name-bottom

```powershell
Move-PaSecurityPolicy [-Name] <string> -Bottom [-WhatIf] [-Confirm] 
```

### name-top

```powershell
Move-PaSecurityPolicy [-Name] <string> -Top [-WhatIf] [-Confirm] 
```

### name-after

```powershell
Move-PaSecurityPolicy [-Name] <string> -After <string> [-WhatIf] [-Confirm] 
```

### name-before

```powershell
Move-PaSecurityPolicy [-Name] <string> -Before <string> [-WhatIf] [-Confirm] 
```

### paobject-bottom

```powershell
Move-PaSecurityPolicy [-PaSecurityPolicy] <PaSecurityPolicy> -Bottom [-WhatIf] [-Confirm] 
```

### paobject-top

```powershell
Move-PaSecurityPolicy [-PaSecurityPolicy] <PaSecurityPolicy> -Top [-WhatIf] [-Confirm] 
```

### paobject-after

```powershell
Move-PaSecurityPolicy [-PaSecurityPolicy] <PaSecurityPolicy> -After <string> [-WhatIf] [-Confirm] 
```

### paobject-before

```powershell
Move-PaSecurityPolicy [-PaSecurityPolicy] <PaSecurityPolicy> -Before <string> [-WhatIf] [-Confirm] 
```

## Description


## Examples

## Parameters

### -After


```asciidoc
Type: string
Parameter Sets: name-after, paobject-after
Aliases: 

Required: true
Position: Named
Default value: 
Accept pipeline input: false
Accept wildcard characters: 
```
### -Before


```asciidoc
Type: string
Parameter Sets: name-before, paobject-before
Aliases: 

Required: true
Position: Named
Default value: 
Accept pipeline input: false
Accept wildcard characters: 
```
### -Bottom


```asciidoc
Type: switch
Parameter Sets: name-bottom, paobject-bottom
Aliases: 

Required: true
Position: Named
Default value: 
Accept pipeline input: false
Accept wildcard characters: 
```
### -Confirm


```asciidoc
Type: switch
Parameter Sets: All
Aliases: cf

Required: false
Position: Named
Default value: 
Accept pipeline input: false
Accept wildcard characters: 
```
### -Name


```asciidoc
Type: string
Parameter Sets: name-bottom, name-top, name-after, name-before
Aliases: 

Required: true
Position: 0
Default value: 
Accept pipeline input: false
Accept wildcard characters: 
```
### -PaSecurityPolicy


```asciidoc
Type: PaSecurityPolicy
Parameter Sets: paobject-bottom, paobject-top, paobject-after, paobject-before
Aliases: 

Required: true
Position: 0
Default value: 
Accept pipeline input: true (ByValue)
Accept wildcard characters: 
```
### -Top


```asciidoc
Type: switch
Parameter Sets: name-top, paobject-top
Aliases: 

Required: true
Position: Named
Default value: 
Accept pipeline input: false
Accept wildcard characters: 
```
### -WhatIf


```asciidoc
Type: switch
Parameter Sets: All
Aliases: wi

Required: false
Position: Named
Default value: 
Accept pipeline input: false
Accept wildcard characters: 
```
