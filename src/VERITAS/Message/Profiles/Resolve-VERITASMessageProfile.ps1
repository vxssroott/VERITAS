function Resolve-VERITASMessageProfile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$InstitutionId,

        [Parameter(Mandatory)]
        [string]$Environment,

        [Parameter(Mandatory)]
        [string]$TransactionType
    )

    $repositoryRoot = (Get-Location).Path

    $registryPath =
        Join-Path $repositoryRoot "config\message\registry.json"

    if (-not (Test-Path $registryPath)) {
        throw "Message profile registry not found: $registryPath"
    }

    $registry =
        Get-Content $registryPath -Raw |
        ConvertFrom-Json

    $matches = @(
        $registry.profiles |
        Where-Object {
            $_.institutionId -eq $InstitutionId -and
            $_.environment -eq $Environment -and
            $_.transactionType -eq $TransactionType
        }
    )

    if ($matches.Count -eq 0) {
        return [pscustomobject]@{
            status = "UNRESOLVED"
            profile = $null
            reason = "No message profile is configured."
        }
    }

    if ($matches.Count -gt 1) {
        return [pscustomobject]@{
            status = "AMBIGUOUS"
            profile = $null
            reason = "Multiple message profiles match the transaction."
        }
    }

    return [pscustomobject]@{
        status = "RESOLVED"
        profile = $matches[0]
        reason = "Message profile resolved."
    }
}
