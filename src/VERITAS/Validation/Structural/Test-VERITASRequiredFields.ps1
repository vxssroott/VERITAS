function Test-VERITASRequiredFields {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [object]$Profile
    )

    $missing = New-Object System.Collections.Generic.List[string]

    if ($null -eq $Transaction.transactionData) {
        foreach ($field in $Profile.requiredFields) {
            $missing.Add($field)
        }
    }
    else {
        foreach ($field in $Profile.requiredFields) {

            $property =
                $Transaction.transactionData.PSObject.Properties |
                Where-Object { $_.Name -eq $field }

            if (
                $null -eq $property -or
                [string]::IsNullOrWhiteSpace([string]$property.Value)
            ) {
                $missing.Add($field)
            }
        }
    }

    return [pscustomobject]@{
        valid = ($missing.Count -eq 0)
        missingFields = @($missing)
    }
}
