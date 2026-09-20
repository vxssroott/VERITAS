function Test-VERITASValidationGate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$ValidationResult
    )

    if ($ValidationResult.status -eq "INVALID") {
        return [pscustomobject]@{
            eligible = $false
            decision = "DENY"
            reason = "Transaction contains validation failures."
        }
    }

    if ($ValidationResult.status -eq "UNRESOLVED") {
        return [pscustomobject]@{
            eligible = $false
            decision = "UNRESOLVED"
            reason = "Transaction validation contains unresolved authoritative conditions."
        }
    }

    return [pscustomobject]@{
        eligible = $true
        decision = "ALLOW"
        reason = "Configured validation checks passed."
    }
}
