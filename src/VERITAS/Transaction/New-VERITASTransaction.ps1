function New-VERITASTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$InstitutionId,

        [Parameter(Mandatory)]
        [string]$TransactionType,

        [string]$Environment = "DEVELOPMENT",

        [hashtable]$TransactionData = @{},

        [string]$CreatedBy = "UNRESOLVED"
    )

    if ([string]::IsNullOrWhiteSpace($InstitutionId)) {
        throw "InstitutionId is required."
    }

    if ([string]::IsNullOrWhiteSpace($TransactionType)) {
        throw "TransactionType is required."
    }

    $now = [DateTime]::UtcNow.ToString("o")

    $transaction = [ordered]@{
        transactionId = New-VERITASTransactionId
        institutionId = $InstitutionId
        environment = $Environment
        transactionType = $TransactionType
        version = 1
        state = "DRAFT"
        createdAt = $now
        updatedAt = $now

        createdBy = [ordered]@{
            identity = $CreatedBy
        }

        authorityContext = $null

        transactionData = $TransactionData

        workflow = [ordered]@{
            currentState = "DRAFT"
            stateVersion = 1
            lastTransitionAt = $now
            lastTransitionBy = $CreatedBy
        }

        integrity = [ordered]@{
            algorithm = "SHA-256"
            canonicalDigest = ""
        }

        metadata = [ordered]@{
            executionLocked = $true
            consentRequired = $true
            transmissionEnabled = $false
            acknowledgementObserved = $false
            settlementObserved = $false
        }
    }

    $transaction.integrity.canonicalDigest =
        Get-VERITASTransactionDigest -Transaction ([pscustomobject]$transaction)

    return [pscustomobject]$transaction
}
