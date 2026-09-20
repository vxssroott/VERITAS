function Test-VERITASExecutionEligibility {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Identity,

        [Parameter(Mandatory = $true)]
        $Authority,

        [Parameter(Mandatory = $true)]
        $Capabilities,

        [Parameter(Mandatory = $true)]
        $PolicyDecision
    )

    $Reasons = New-Object System.Collections.Generic.List[string]

    if ($Identity.AuthenticationState -ne 'AUTHENTICATED') {
        $Reasons.Add('Identity is not authenticated.')
    }

    if ($Authority.ResolutionState -ne 'RESOLVED') {
        $Reasons.Add('Authority is not resolved.')
    }

    if ($Authority.AuthorityState -ne 'ACTIVE') {
        $Reasons.Add('Authority is not active.')
    }

    if ($Capabilities.State -ne 'RESOLVED') {
        $Reasons.Add('Capabilities are not resolved.')
    }

    if ($Capabilities.Capabilities.Count -eq 0) {
        $Reasons.Add('No applicable capabilities are configured.')
    }

    if ($PolicyDecision.Decision -eq 'DENY') {
        $Reasons.Add('Policy explicitly denied the operation.')
    }

    if ($PolicyDecision.Decision -eq 'UNRESOLVED') {
        $Reasons.Add('Policy decision is unresolved.')
    }

    if ($Reasons.Count -gt 0) {

        return [pscustomobject]@{
            Eligible = $false
            State    = 'NOT_ELIGIBLE'
            Reasons  = @($Reasons)
        }
    }

    if ($PolicyDecision.Decision -ne 'ALLOW') {

        return [pscustomobject]@{
            Eligible = $false
            State    = 'NOT_ELIGIBLE'
            Reasons  = @(
                "Policy decision is '$($PolicyDecision.Decision)'."
            )
        }
    }

    [pscustomobject]@{
        Eligible = $true
        State    = 'ELIGIBLE_FOR_CONSENT'
        Reasons  = @(
            'Identity authenticated.',
            'Authority resolved.',
            'Authority active.',
            'Capabilities resolved.',
            'Policy allowed operation.',
            'Explicit execution consent remains required.'
        )
    }
}
