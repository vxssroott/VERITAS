function Invoke-VERITASTransactionStateTransition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [string]$ToState,

        [Parameter(Mandatory)]
        [string]$RequestedBy,

        [string]$Reason = "No reason supplied.",

        [int]$ExpectedVersion
    )

    if (-not $PSBoundParameters.ContainsKey("ExpectedVersion")) {
        $ExpectedVersion = [int]$Transaction.version
    }

    $integrity = Test-VERITASTransactionIntegrity -Transaction $Transaction

    if (-not $integrity.valid) {
        throw "Transaction integrity verification failed. State transition blocked."
    }

    $versionCheck =
        Test-VERITASTransactionVersionMatch `
            -Transaction $Transaction `
            -ExpectedVersion $ExpectedVersion

    if (-not $versionCheck.matches) {
        throw "Transaction version conflict. State transition blocked."
    }

    $transition =
        Test-VERITASTransactionStateTransition `
            -FromState $Transaction.state `
            -ToState $ToState

    if (-not $transition.allowed) {
        throw "Unconfigured transaction state transition: $($Transaction.state) -> $ToState"
    }

    $now = [DateTime]::UtcNow.ToString("o")

    $next = [ordered]@{}

    foreach ($property in $Transaction.PSObject.Properties) {
        $next[$property.Name] = $property.Value
    }

    $next.state = $ToState
    $next.updatedAt = $now

    $next.workflow = [ordered]@{
        currentState = $ToState
        stateVersion = [int]$Transaction.version + 1
        lastTransitionAt = $now
        lastTransitionBy = $RequestedBy
        previousState = $Transaction.state
        reason = $Reason
    }

    $next.version = [int]$Transaction.version + 1

    if ($null -eq $next.metadata) {
        $next.metadata = [ordered]@{}
    }

    $next.metadata.lastTransitionBy = $RequestedBy
    $next.metadata.previousState = $Transaction.state

    $next.integrity = [ordered]@{
        algorithm = "SHA-256"
        canonicalDigest = ""
    }

    $next.integrity.canonicalDigest =
        Get-VERITASTransactionDigest -Transaction ([pscustomobject]$next)

    return [pscustomobject]$next
}
