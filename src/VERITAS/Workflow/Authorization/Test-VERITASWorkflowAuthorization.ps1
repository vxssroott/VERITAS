function Test-VERITASWorkflowAuthorization {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Action,

        [Parameter(Mandatory)]
        [object]$AuthorityContext,

        [Parameter(Mandatory)]
        [object[]]$Capabilities,

        [Parameter(Mandatory)]
        [string]$Environment
    )

    if ($null -eq $AuthorityContext) {
        return [pscustomobject]@{
            decision = "UNRESOLVED"
            authorized = $false
            reason = "Authority context is unavailable."
        }
    }

    if ($AuthorityContext.status -ne "RESOLVED") {
        return [pscustomobject]@{
            decision = "UNRESOLVED"
            authorized = $false
            reason = "Authority context is not resolved."
        }
    }

    if ($AuthorityContext.active -eq $false) {
        return [pscustomobject]@{
            decision = "DENY"
            authorized = $false
            reason = "Authority is inactive."
        }
    }

    $operation = $Action.requiredOperation

    $matchingCapability = @(
        $Capabilities |
        Where-Object {
            $_.status -eq "ACTIVE" -and
            $_.environment -eq $Environment -and
            $_.operations -contains $operation
        }
    )

    if ($matchingCapability.Count -eq 0) {
        return [pscustomobject]@{
            decision = "DENY"
            authorized = $false
            reason = "Required workflow capability is not configured."
        }
    }

    return [pscustomobject]@{
        decision = "ALLOW"
        authorized = $true
        reason = "Authority and required capability are resolved."
        operation = $operation
        capabilityIds = @(
            $matchingCapability |
            ForEach-Object { $_.capabilityId }
        )
    }
}
