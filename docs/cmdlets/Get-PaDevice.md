# Get-PaDevice

## Synopsis

Establishes initial connection to Palo Alto API.

## Syntax

### ApiKey (Default)

```powershell
Get-PaDevice [-DeviceAddress] <String> [-ApiKey] <String> [[-Port] <Int32>] [-HttpOnly] [-SkipCertificateCheck] [-Quiet] 
```

### Credential

```powershell
Get-PaDevice [-DeviceAddress] <String> [-Credential] <PSCredential> [[-Port] <Int32>] [-HttpOnly] [-SkipCertificateCheck] [-Quiet] 
```

## Description

The Get-PaDevice cmdlet establishes and validates connection parameters to allow further communications to the Palo Alto API. The cmdlet needs at least two parameters:
 - The device IP address or FQDN
 - A valid API key or PSCredential object

The cmdlet returns an object containing details of the connection, but this can be discarded or saved as desired; the returned object is not necessary to provide to further calls to the API.

## Examples

### Example 1

```
PS c:\> Get-PaDevice -DeviceAddress "pa.example.com" -ApiKey "LUFRPT1asdfPR2JtSDl5M2tjfdsaTktBeTkyaGZMTURasdfTTU9BZm89OGtKN0F"
```


Connects to Palo Alto Device using the default port (443) over SSL (HTTPS) using an API Key










### Example 2

```
PS c:\> Get-PaDevice -DeviceAddress "pa.example.com" -Credential (Get-Credential)
```

Prompts the user for username and password and connects to the Palo Alto Device with those creds.  This will generate a keygen call and the user's API Key will be used for all subsequent calls.










## Parameters

### -DeviceAddress

Fully-qualified domain name for the Palo Alto Device. Don't include the protocol ("https://" or "http://").

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
### -ApiKey

ApiKey used to access Palo Alto Device.

```asciidoc
Type: String
Parameter Sets: ApiKey
Aliases: 

Required: true
Position: 2
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -Credential

PSCredental object to provide as an alternative to an API Key.

```asciidoc
Type: PSCredential
Parameter Sets: Credential
Aliases: 

Required: true
Position: 2
Default value: 
Accept pipeline input: false
Accept wildcard characters: false
```
### -Port

The port the Palo Alto Device is using for management communicatins. This defaults to port 443 over HTTPS, and port 80 over HTTP.

```asciidoc
Type: Int32
Parameter Sets: All
Aliases: 

Required: false
Position: 3
Default value: 443
Accept pipeline input: false
Accept wildcard characters: false
```
### -HttpOnly

When specified, configures the API connection to run over HTTP rather than the default HTTPS. Not recommended!

```asciidoc
Type: SwitchParameter
Parameter Sets: All
Aliases: http

Required: false
Position: named
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -SkipCertificateCheck

When used, all certificate warnings are ignored.

```asciidoc
Type: SwitchParameter
Parameter Sets: All
Aliases: 

Required: false
Position: named
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```
### -Quiet

When used, the cmdlet returns nothing on success.

```asciidoc
Type: SwitchParameter
Parameter Sets: All
Aliases: q

Required: false
Position: named
Default value: False
Accept pipeline input: false
Accept wildcard characters: false
```


