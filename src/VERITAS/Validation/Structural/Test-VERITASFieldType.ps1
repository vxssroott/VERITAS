function Test-VERITASFieldType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FieldName,

        [Parameter(Mandatory)]
        [object]$Value,

        [Parameter(Mandatory)]
        [object]$Rule
    )

    if ($null -eq $Value) {
        return [pscustomobject]@{
            valid = $false
            field = $FieldName
            rule = $Rule.type
            reason = "Value is null."
        }
    }

    $text = [string]$Value

    switch ($Rule.type) {

        "NON_EMPTY_TEXT" {
            $valid = -not [string]::IsNullOrWhiteSpace($text)

            return [pscustomobject]@{
                valid = $valid
                field = $FieldName
                rule = $Rule.type
                reason = if ($valid) {
                    "Non-empty text verified."
                }
                else {
                    "Value is empty."
                }
            }
        }

        "CURRENCY_CODE" {
            $valid = $text -match '^[A-Z]{3}$'

            return [pscustomobject]@{
                valid = $valid
                field = $FieldName
                rule = $Rule.type
                reason = if ($valid) {
                    "Currency code format verified."
                }
                else {
                    "Currency code format invalid."
                }
            }
        }

        "POSITIVE_DECIMAL" {
            $number = 0
            $parsed = [decimal]::TryParse(
                $text,
                [Globalization.NumberStyles]::Number,
                [Globalization.CultureInfo]::InvariantCulture,
                [ref]$number
            )

            $valid = $parsed -and ($number -gt 0)

            return [pscustomobject]@{
                valid = $valid
                field = $FieldName
                rule = $Rule.type
                reason = if ($valid) {
                    "Positive decimal verified."
                }
                else {
                    "Value is not a positive decimal."
                }
            }
        }

        "ISO_DATE" {
            $date = [DateTime]::MinValue

            $valid =
                [DateTime]::TryParseExact(
                    $text,
                    "yyyy-MM-dd",
                    [Globalization.CultureInfo]::InvariantCulture,
                    [Globalization.DateTimeStyles]::None,
                    [ref]$date
                )

            return [pscustomobject]@{
                valid = $valid
                field = $FieldName
                rule = $Rule.type
                reason = if ($valid) {
                    "ISO date format verified."
                }
                else {
                    "ISO date format invalid."
                }
            }
        }

        "BIC" {
            $valid =
                $text -match '^[A-Z0-9]{8}([A-Z0-9]{3})?$'

            return [pscustomobject]@{
                valid = $valid
                field = $FieldName
                rule = $Rule.type
                reason = if ($valid) {
                    "BIC structural format verified."
                }
                else {
                    "BIC structural format invalid."
                }
            }
        }

        "ENUM" {
            $valid =
                $Rule.allowed -contains $text

            return [pscustomobject]@{
                valid = $valid
                field = $FieldName
                rule = $Rule.type
                reason = if ($valid) {
                    "Configured enumeration value verified."
                }
                else {
                    "Value is not in configured enumeration."
                }
            }
        }

        default {
            return [pscustomobject]@{
                valid = $false
                field = $FieldName
                rule = $Rule.type
                reason = "Unknown validation rule. State remains unresolved."
            }
        }
    }
}
