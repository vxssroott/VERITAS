function Get-VERITASTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TransactionId,

        [string]$RootPath
    )

    if ([string]::IsNullOrWhiteSpace($RootPath)) {
        $RootPath = Join-Path $HOME "Projects/VERITAS/runtime/transactions"
    }

    $path =
        Join-Path $RootPath "$TransactionId/current.json"

    if (-not (Test-Path $path)) {
        return $null
    }

    return Get-Content $path -Raw | ConvertFrom-Json
}
