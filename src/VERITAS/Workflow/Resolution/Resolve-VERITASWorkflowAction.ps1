function Resolve-VERITASWorkflowAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Workflow,

        [Parameter(Mandatory)]
        [string]$ActionId,

        [Parameter(Mandatory)]
        [string]$CurrentState
    )

    if ($null -eq $Workflow.actions) {
        return [pscustomobject]@{
            status = "UNRESOLVED"
            action = $null
            reason = "Workflow contains no actions."
        }
    }

    $matches = @(
        $Workflow.actions |
        Where-Object {
            $_.actionId -eq $ActionId -and
            $_.fromStates -contains $CurrentState
        }
    )

    if ($matches.Count -eq 0) {
        return [pscustomobject]@{
            status = "DENIED"
            action = $null
            reason = "Action is not configured for the current state."
        }
    }

    if ($matches.Count -gt 1) {
        return [pscustomobject]@{
            status = "AMBIGUOUS"
            action = $null
            reason = "Multiple matching workflow actions found."
        }
    }

    return [pscustomobject]@{
        status = "RESOLVED"
        action = $matches[0]
        reason = "Workflow action resolved."
    }
}
