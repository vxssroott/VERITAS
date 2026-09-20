function Test-VERITASTransactionStateTransition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FromState,

        [Parameter(Mandatory)]
        [string]$ToState
    )

    # Resolve repository root from the current VERITAS project.
    $repositoryRoot = (Get-Location).Path

    $graphPath = Join-Path `
        $repositoryRoot `
        "config\transaction\state-graph.json"

    if (-not (Test-Path $graphPath)) {
        throw "Transaction state graph not found: $graphPath"
    }

    $graph = Get-Content $graphPath -Raw | ConvertFrom-Json

    $match = $graph.transitions |
        Where-Object {
            $_.from -eq $FromState -and
            $_.to -eq $ToState
        }

    if ($null -eq $match) {
        return [pscustomobject]@{
            allowed = $false
            fromState = $FromState
            toState = $ToState
            reason = "Transition is not configured."
        }
    }

    return [pscustomobject]@{
        allowed = $true
        fromState = $FromState
        toState = $ToState
        reason = "Transition is configured."
    }
}
