function Invoke-VERITASWorkflowAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [object]$Workflow,

        [Parameter(Mandatory)]
        [string]$ActionId,

        [Parameter(Mandatory)]
        [object]$AuthorityContext,

        [Parameter(Mandatory)]
        [object[]]$Capabilities,

        [Parameter(Mandatory)]
        [string]$RequestedBy,

        [string]$Reason = "Workflow action requested.",

        [int]$ExpectedVersion
    )

    if (-not $PSBoundParameters.ContainsKey("ExpectedVersion")) {
        $ExpectedVersion = [int]$Transaction.version
    }

    $actionResolution =
        Resolve-VERITASWorkflowAction `
            -Workflow $Workflow `
            -ActionId $ActionId `
            -CurrentState $Transaction.state

    if ($actionResolution.status -ne "RESOLVED") {
        throw "Workflow action cannot be resolved: $($actionResolution.reason)"
    }

    $action = $actionResolution.action

    $authorization =
        Test-VERITASWorkflowAuthorization `
            -Action $action `
            -AuthorityContext $AuthorityContext `
            -Capabilities $Capabilities `
            -Environment $Transaction.environment

    $preconditions =
        Test-VERITASWorkflowPreconditions `
            -Transaction $Transaction `
            -Action $action `
            -WorkflowAuthorization $authorization

    if (-not $preconditions.eligible) {
        throw (
            "Workflow action blocked. " +
            ($preconditions.reasons -join " ")
        )
    }

    $result =
        Invoke-VERITASTransactionStateTransition `
            -Transaction $Transaction `
            -ToState $action.toState `
            -RequestedBy $RequestedBy `
            -Reason $Reason `
            -ExpectedVersion $ExpectedVersion

    return [pscustomobject]@{
        transaction = $result
        action = $action
        authorization = $authorization
        preconditions = $preconditions
        executionUnlocked = $false
        consentRequired = $true
        externalExecutionPerformed = $false
    }
}
