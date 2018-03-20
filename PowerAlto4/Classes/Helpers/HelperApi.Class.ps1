class HelperApi {
    # TranslateBool
    static [bool] TranslateBool([string]$ApiBool) {
        if ($ApiBool -eq 'yes') {
            return $true
        } elseif ($ApiBool -eq 'no') {
            return $false
        } else {
            Throw "Invalid bool value: $ApiBool"
        }
    }

    # Constructor
    HelperApi () {
    }
}