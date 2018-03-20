class HelperApi {
    # TranslateBool
    static [bool] TranslateBool([string]$ApiBool,[bool]$DefaultValue) {
        if ($ApiBool -eq 'yes') {
            return $true
        } elseif ($ApiBool -eq 'no') {
            return $false
        } elseif ($ApiBool -eq '') {
            return $DefaultValue
        } else {
            Throw "Invalid bool value: $ApiBool"
        }
    }

    # Constructor
    HelperApi () {
    }
}