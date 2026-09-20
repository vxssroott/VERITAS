function Invoke-VERITASMessageConstruction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction
    )

    $profileResolution =
        Resolve-VERITASMessageProfile `
            -InstitutionId $Transaction.institutionId `
            -Environment $Transaction.environment `
            -TransactionType $Transaction.transactionType

    if ($profileResolution.status -ne "RESOLVED") {
        throw "Message profile resolution failed: $($profileResolution.reason)"
    }

    $message =
        New-VERITASCanonicalMessage `
            -Transaction $Transaction `
            -Profile $profileResolution.profile

    $integrity =
        Test-VERITASMessageIntegrity `
            -Message $message

    if (-not $integrity.valid) {
        throw "Constructed message failed integrity verification."
    }

    return [pscustomobject]@{
        status = "CONSTRUCTED"
        transactionId = $Transaction.transactionId
        transactionVersion = $Transaction.version
        profile = $profileResolution.profile
        message = $message
        integrity = $integrity
        transmissionPerformed = $false
        externalDeliveryObserved = $false
    }
}
