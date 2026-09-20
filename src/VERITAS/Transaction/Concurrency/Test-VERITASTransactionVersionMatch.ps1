function Test-VERITASTransactionVersionMatch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [int]$ExpectedVersion
    )

    $actual = [int]$Transaction.version

    return [pscustomobject]@{
        matches = ($actual -eq $ExpectedVersion)
        expectedVersion = $ExpectedVersion
        actualVersion = $actual
        reason = if ($actual -eq $ExpectedVersion) {
            "Transaction version matches expected version."
        }
        else {
            "Optimistic concurrency conflict detected."
        }
    }
}
