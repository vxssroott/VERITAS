function Invoke-VERITASTransactionEngine {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet(
            "Create",
            "Read",
            "Transition",
            "Verify"
        )]
        [string]$Operation,

        [object]$Transaction,

        [string]$TransactionId,

        [string]$InstitutionId,

        [string]$TransactionType,

        [string]$ToState,

        [string]$RequestedBy,

        [string]$Reason,

        [int]$ExpectedVersion
    )

    switch ($Operation) {

        "Create" {
            if ([string]::IsNullOrWhiteSpace($InstitutionId)) {
                throw "InstitutionId is required."
            }

            if ([string]::IsNullOrWhiteSpace($TransactionType)) {
                throw "TransactionType is required."
            }

            $created =
                New-VERITASTransaction `
                    -InstitutionId $InstitutionId `
                    -TransactionType $TransactionType `
                    -CreatedBy $(if ($RequestedBy) { $RequestedBy } else { "UNRESOLVED" })

            return $created
        }

        "Read" {
            if ([string]::IsNullOrWhiteSpace($TransactionId)) {
                throw "TransactionId is required."
            }

            return Get-VERITASTransaction -TransactionId $TransactionId
        }

        "Verify" {
            if ($null -eq $Transaction) {
                throw "Transaction object is required."
            }

            return Test-VERITASTransactionIntegrity -Transaction $Transaction
        }

        "Transition" {
            if ($null -eq $Transaction) {
                throw "Transaction object is required."
            }

            if ([string]::IsNullOrWhiteSpace($ToState)) {
                throw "ToState is required."
            }

            if ([string]::IsNullOrWhiteSpace($RequestedBy)) {
                throw "RequestedBy is required."
            }

            return Invoke-VERITASTransactionStateTransition `
                -Transaction $Transaction `
                -ToState $ToState `
                -RequestedBy $RequestedBy `
                -Reason $(if ($Reason) { $Reason } else { "No reason supplied." }) `
                -ExpectedVersion $(if ($PSBoundParameters.ContainsKey("ExpectedVersion")) { $ExpectedVersion } else { [int]$Transaction.version })
        }
    }
}
