function Invoke-VERITASWorkflow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [string]$ActionId,

        [Parameter(Mandatory)]
        [object]$AuthorityContext,

        [Parameter(Mandatory)]
        [object[]]$Capabilities,

        [Parameter(Mandatory)]
        [string]$RequestedBy,

        [string]$Reason = "Workflow orchestration request.",

        [int]$ExpectedVersion
    )

    if (-not $PSBoundParameters.ContainsKey("ExpectedVersion")) {
        $ExpectedVersion = [int]$Transaction.version
    }

    $workflowResolution =
        Resolve-VERITASWorkflow `
            -InstitutionId $Transaction.institutionId `
            -Environment $Transaction.environment `
            -TransactionType $Transaction.transactionType

    if ($workflowResolution.status -ne "RESOLVED") {
        throw "Workflow resolution failed: $($workflowResolution.reason)"
    }

    $result =
        Invoke-VERITASWorkflowAction `
            -Transaction $Transaction `
            -Workflow $workflowResolution.workflow `
            -ActionId $ActionId `
            -AuthorityContext $AuthorityContext `
            -Capabilities $Capabilities `
            -RequestedBy $RequestedBy `
            -Reason $Reason `
            -ExpectedVersion $ExpectedVersion

    return [pscustomobject]@{
        workflow = $workflowResolution.workflow
        transaction = $result.transaction
        action = $result.action
        authorization = $result.authorization
        preconditions = $result.preconditions
        executionUnlocked = $false
        consentRequired = $true
        externalExecutionPerformed = $false
    }
}
