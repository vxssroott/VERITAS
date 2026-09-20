function Get-VERITASTransactionDigest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction
    )

    $canonical = ConvertTo-VERITASCanonicalJson -InputObject $Transaction

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($canonical)

    $sha256 = [System.Security.Cryptography.SHA256]::Create()

    try {
        $hash = $sha256.ComputeHash($bytes)
    }
    finally {
        $sha256.Dispose()
    }

    return ([System.BitConverter]::ToString($hash) -replace "-", "").ToLowerInvariant()
}
