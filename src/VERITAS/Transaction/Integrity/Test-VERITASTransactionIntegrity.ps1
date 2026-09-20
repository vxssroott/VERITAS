function Test-VERITASTransactionIntegrity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction
    )

    if ($null -eq $Transaction.integrity) {
        return [pscustomobject]@{
            valid = $false
            reason = "Integrity metadata missing."
        }
    }

    $expected = $Transaction.integrity.canonicalDigest

    $copy = [ordered]@{}

    foreach ($property in $Transaction.PSObject.Properties) {
        $copy[$property.Name] = $property.Value
    }

    $copy.integrity = [ordered]@{
        algorithm = $Transaction.integrity.algorithm
        canonicalDigest = ""
    }

    $actual = Get-VERITASTransactionDigest -Transaction ([pscustomobject]$copy)

    return [pscustomobject]@{
        valid = ($expected -eq $actual)
        expectedDigest = $expected
        actualDigest = $actual
        reason = if ($expected -eq $actual) {
            "Canonical transaction integrity verified."
        }
        else {
            "Canonical transaction digest mismatch."
        }
    }
}
