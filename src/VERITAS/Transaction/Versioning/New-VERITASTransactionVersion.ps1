function New-VERITASTransactionVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [hashtable]$Changes,

        [string]$ModifiedBy = "UNRESOLVED"
    )

    if ($null -eq $Transaction.transactionId) {
        throw "Transaction identity is required."
    }

    if ($Transaction.version -lt 1) {
        throw "Invalid transaction version."
    }

    $next = [ordered]@{}

    foreach ($property in $Transaction.PSObject.Properties) {
        $next[$property.Name] = $property.Value
    }

    foreach ($key in $Changes.Keys) {
        $next[$key] = $Changes[$key]
    }

    $next.version = [int]$Transaction.version + 1
    $next.updatedAt = [DateTime]::UtcNow.ToString("o")

    if ($null -eq $next.metadata) {
        $next.metadata = [ordered]@{}
    }

    $next.metadata.lastModifiedBy = $ModifiedBy
    $next.metadata.previousVersion = [int]$Transaction.version

    $next.integrity = [ordered]@{
        algorithm = "SHA-256"
        canonicalDigest = ""
    }

    $next.integrity.canonicalDigest =
        Get-VERITASTransactionDigest -Transaction ([pscustomobject]$next)

    return [pscustomobject]$next
}
