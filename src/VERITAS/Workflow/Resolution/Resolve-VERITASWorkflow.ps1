function Resolve-VERITASWorkflow {
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
        Join-Path $repositoryRoot "config\workflow\registry.json"

    if (-not (Test-Path $registryPath)) {
        throw "Workflow registry not found: $registryPath"
    }

    $registry =
        Get-Content $registryPath -Raw |
        ConvertFrom-Json

    $matches = @(
        $registry.workflows |
        Where-Object {
            $_.institutionId -eq $InstitutionId -and
            $_.environment -eq $Environment -and
            $_.transactionTypes -contains $TransactionType
        }
    )

    if ($matches.Count -eq 0) {
        return [pscustomobject]@{
            status = "UNRESOLVED"
            workflow = $null
            reason = "No matching institution workflow configured."
        }
    }

    if ($matches.Count -gt 1) {
        return [pscustomobject]@{
            status = "AMBIGUOUS"
            workflow = $null
            reason = "Multiple matching workflows configured."
        }
    }

    return [pscustomobject]@{
        status = "RESOLVED"
        workflow = $matches[0]
        reason = "Institution workflow resolved."
    }
}
