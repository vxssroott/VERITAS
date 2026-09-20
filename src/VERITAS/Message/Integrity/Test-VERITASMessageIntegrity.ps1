function Test-VERITASMessageIntegrity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Message
    )

    if ($null -eq $Message.integrity) {
        return [pscustomobject]@{
            valid = $false
            reason = "Message integrity metadata missing."
        }
    }

    $expected =
        $Message.integrity.digest

    $copy = [ordered]@{}

    foreach ($property in $Message.PSObject.Properties) {
        $copy[$property.Name] = $property.Value
    }

    $copy.integrity = [ordered]@{
        algorithm = $Message.integrity.algorithm
        digest = ""
    }

    $canonical =
        $copy |
        ConvertTo-Json -Depth 100 -Compress

    $bytes =
        [System.Text.Encoding]::UTF8.GetBytes($canonical)

    $sha =
        [System.Security.Cryptography.SHA256]::Create()

    try {
        $hash = $sha.ComputeHash($bytes)
    }
    finally {
        $sha.Dispose()
    }

    $actual =
        ([System.BitConverter]::ToString($hash) -replace "-", "").ToLowerInvariant()

    return [pscustomobject]@{
        valid = ($expected -eq $actual)
        expectedDigest = $expected
        actualDigest = $actual
        reason = if ($expected -eq $actual) {
            "Canonical message integrity verified."
        }
        else {
            "Canonical message digest mismatch."
        }
    }
}
