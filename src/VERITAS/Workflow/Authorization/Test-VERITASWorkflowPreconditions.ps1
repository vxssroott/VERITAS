function Test-VERITASWorkflowPreconditions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [object]$Action,

        [Parameter(Mandatory)]
        [object]$WorkflowAuthorization
    )

    $reasons = New-Object System.Collections.Generic.List[string]

    if ($null -eq $Transaction.transactionId) {
        $reasons.Add("Transaction identity missing.")
    }

    if ($Transaction.version -lt 1) {
        $reasons.Add("Invalid transaction version.")
    }

    if ($null -eq $Transaction.integrity) {
        $reasons.Add("Transaction integrity metadata missing.")
    }

    if (-not $WorkflowAuthorization.authorized) {
        $reasons.Add(
            "Workflow authorization is not satisfied."
        )
    }

    if ($Action.fromStates -notcontains $Transaction.state) {
        $reasons.Add(
            "Transaction is not in a valid state for this action."
        )
    }

    if ($reasons.Count -gt 0) {
        return [pscustomobject]@{
            eligible = $false
            decision = "UNRESOLVED"
            reasons = @($reasons)
        }
    }

    return [pscustomobject]@{
        eligible = $true
        decision = "ELIGIBLE"
        reasons = @(
            "Transaction identity resolved."
            "Transaction version valid."
            "Transaction integrity metadata present."
            "Workflow authorization satisfied."
            "Transaction state permits action."
        )
    }
}
