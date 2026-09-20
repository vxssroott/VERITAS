function Test-VERITASTransactionSemantics {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction
    )

    $issues = New-Object System.Collections.Generic.List[string]

    if ($Transaction.transactionType -eq "SWIFT_TRANSFER") {

        $data = $Transaction.transactionData

        if ($null -eq $data) {
            $issues.Add("Transaction data is unavailable.")
        }
        else {

            if (
                $null -ne $data.amount -and
                $null -ne $data.currency
            ) {
                $amount = 0

                $parsed =
                    [decimal]::TryParse(
                        [string]$data.amount,
                        [Globalization.NumberStyles]::Number,
                        [Globalization.CultureInfo]::InvariantCulture,
                        [ref]$amount
                    )

                if (-not $parsed -or $amount -le 0) {
                    $issues.Add(
                        "SWIFT transfer amount must be greater than zero."
                    )
                }
            }

            if (
                $null -ne $data.charges -and
                @("OUR","SHA","BEN") -notcontains [string]$data.charges
            ) {
                $issues.Add(
                    "Configured charge type is invalid."
                )
            }

            if (
                $null -ne $data.currency -and
                ([string]$data.currency).Length -ne 3
            ) {
                $issues.Add(
                    "Currency must use a three-character code."
                )
            }
        }
    }

    return [pscustomobject]@{
        status = if ($issues.Count -eq 0) {
            "VALID"
        }
        else {
            "INVALID"
        }

        issues = @($issues)
    }
}
