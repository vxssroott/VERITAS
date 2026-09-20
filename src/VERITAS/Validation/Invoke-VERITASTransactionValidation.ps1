function Invoke-VERITASTransactionValidation {
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
        return [pscustomobject]@{
            transactionId = $Transaction.transactionId
            transactionVersion = $Transaction.version
            status = "UNRESOLVED"
            profile = $profileResolution
            structural = $null
            semantic = $null
            references = $null
            business = $null
            checkedAt = [DateTime]::UtcNow.ToString("o")
        }
    }

    $profile = $profileResolution.profile

    $structural =
        Test-VERITASTransactionStructure `
            -Transaction $Transaction `
            -Profile $profile

    $semantic =
        Test-VERITASTransactionSemantics `
            -Transaction $Transaction

    $references =
        Resolve-VERITASReferenceValidation `
            -Transaction $Transaction

    $business =
        Resolve-VERITASTransactionBusinessValidation `
            -Transaction $Transaction

    $status = "VALID"

    if ($structural.status -eq "INVALID") {
        $status = "INVALID"
    }
    elseif ($semantic.status -eq "INVALID") {
        $status = "INVALID"
    }
    elseif ($references.status -eq "INVALID") {
        $status = "INVALID"
    }
    elseif (
        $references.status -eq "UNVERIFIED" -or
        $business.status -eq "UNRESOLVED"
    ) {
        $status = "UNRESOLVED"
    }

    return [pscustomobject]@{
        transactionId = $Transaction.transactionId
        transactionVersion = $Transaction.version
        status = $status
        profile = [pscustomobject]@{
            profileId = $profile.profileId
            standard = $profile.standard
            messageType = $profile.messageType
        }
        structural = $structural
        semantic = $semantic
        references = $references
        business = $business
        checkedAt = [DateTime]::UtcNow.ToString("o")
    }
}
