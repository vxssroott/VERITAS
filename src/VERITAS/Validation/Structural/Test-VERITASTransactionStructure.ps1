function Test-VERITASTransactionStructure {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$Transaction,

        [Parameter(Mandatory = $false)]
        [object]$Profile,

        [Parameter(Mandatory = $false)]
        [string]$ContractPath
    )

    $errors = New-Object System.Collections.Generic.List[string]
    $warnings = New-Object System.Collections.Generic.List[string]

    if ($null -eq $Transaction) {
        $errors.Add("Transaction object is null.")
    }
    else {

        $requiredProperties = @(
            "transactionId",
            "institutionId",
            "environment",
            "transactionType",
            "amount",
            "currency",
            "beneficiary",
            "destinationAccount",
            "bic",
            "valueDate",
            "charges"
        )

        foreach ($propertyName in $requiredProperties) {

            $property = $Transaction.PSObject.Properties[$propertyName]

            if ($null -eq $property) {
                $errors.Add("Missing required property: $propertyName")
                continue
            }

            if ($null -eq $property.Value) {
                $errors.Add("Required property is null: $propertyName")
                continue
            }

            if ($property.Value -is [string]) {
                if ([string]::IsNullOrWhiteSpace([string]$property.Value)) {
                    $errors.Add("Required property is empty: $propertyName")
                }
            }
        }

        if ($null -ne $Transaction.amount) {

            $parsedAmount = 0.0

            $amountIsNumeric = [double]::TryParse(
                [string]$Transaction.amount,
                [ref]$parsedAmount
            )

            if (-not $amountIsNumeric) {
                $errors.Add("Amount must be numeric.")
            }
            elseif ($parsedAmount -lt 0) {
                $errors.Add("Amount cannot be negative.")
            }
        }

        $stringProperties = @(
            "transactionId",
            "institutionId",
            "environment",
            "transactionType",
            "currency",
            "beneficiary",
            "destinationAccount",
            "bic",
            "valueDate",
            "charges"
        )

        foreach ($propertyName in $stringProperties) {

            $property = $Transaction.PSObject.Properties[$propertyName]

            if ($null -eq $property) {
                continue
            }

            if (
                $null -ne $property.Value -and
                -not ($property.Value -is [string])
            ) {
                $errors.Add("Property '$propertyName' must be a string.")
            }
        }

        if ($null -ne $Transaction.currency) {

            if ([string]$Transaction.currency -notmatch '^[A-Za-z]{3}$') {
                $errors.Add(
                    "Currency must use a 3-character ISO-style representation."
                )
            }
        }

        if ($null -ne $Transaction.bic) {

            $bic = [string]$Transaction.bic

            if (
                ($bic.Length -ne 8) -and
                ($bic.Length -ne 11)
            ) {
                $errors.Add(
                    "BIC must contain 8 or 11 characters."
                )
            }
        }

        if ($null -ne $Transaction.valueDate) {

            $parsedDate = [datetime]::MinValue

            $validDate = [datetime]::TryParseExact(
                [string]$Transaction.valueDate,
                "yyyy-MM-dd",
                [System.Globalization.CultureInfo]::InvariantCulture,
                [System.Globalization.DateTimeStyles]::None,
                [ref]$parsedDate
            )

            if (-not $validDate) {
                $errors.Add(
                    "Value date must use yyyy-MM-dd format."
                )
            }
        }

        if ($null -ne $Transaction.charges) {

            $charges = ([string]$Transaction.charges).ToUpperInvariant()

            if (@("OUR","SHA","BEN") -notcontains $charges) {
                $errors.Add(
                    "Charges must be one of OUR, SHA, or BEN."
                )
            }
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($ContractPath)) {

        if (-not (Test-Path -LiteralPath $ContractPath)) {
            $errors.Add(
                "Transaction contract not found: $ContractPath"
            )
        }
    }

    $status = "VALID"

    if ($errors.Count -gt 0) {
        $status = "INVALID"
    }

    [pscustomobject]@{
        status       = $status
        valid        = ($status -eq "VALID")
        errors       = @($errors.ToArray())
        warnings     = @($warnings.ToArray())
        checkedAtUtc = [DateTime]::UtcNow.ToString("o")
    }
}
