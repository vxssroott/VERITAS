function Save-VERITASTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [string]$RootPath
    )

    if ([string]::IsNullOrWhiteSpace($RootPath)) {
        $RootPath = Join-Path $HOME "Projects/VERITAS/runtime/transactions"
    }

    $transactionPath =
        Join-Path $RootPath $Transaction.transactionId

    $versionPath =
        Join-Path $transactionPath "versions"

    New-Item -ItemType Directory -Force -Path $versionPath | Out-Null

    $currentPath =
        Join-Path $transactionPath "current.json"

    $versionFile =
        Join-Path $versionPath ("v{0}.json" -f $Transaction.version)

    $Transaction |
        ConvertTo-Json -Depth 100 |
        Set-Content $currentPath -Encoding UTF8

    $Transaction |
        ConvertTo-Json -Depth 100 |
        Set-Content $versionFile -Encoding UTF8

    return [pscustomobject]@{
        transactionId = $Transaction.transactionId
        version = $Transaction.version
        currentPath = $currentPath
        versionPath = $versionFile
    }
}
