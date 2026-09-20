function Test-VERITASCapability {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Capability,

        [Parameter(Mandatory = $true)]
        [string]$Operation,

        [string]$Resource,

        [string]$Environment = 'DEVELOPMENT',

        [decimal]$Amount = 0
    )

    if ($Capability.status -ne 'ACTIVE') {
        return [pscustomobject]@{
            Eligible = $false
            Reason   = 'Capability is not active.'
        }
    }

    if (
        $Capability.environments.Count -gt 0 -and
        $Capability.environments -notcontains $Environment
    ) {
        return [pscustomobject]@{
            Eligible = $false
            Reason   = 'Capability does not apply to this environment.'
        }
    }

    if (
        $Capability.operations.Count -gt 0 -and
        $Capability.operations -notcontains $Operation
    ) {
        return [pscustomobject]@{
            Eligible = $false
            Reason   = 'Operation is outside the capability scope.'
        }
    }

    if (
        $Resource -and
        $Capability.resources.Count -gt 0 -and
        $Capability.resources -notcontains $Resource
    ) {
        return [pscustomobject]@{
            Eligible = $false
            Reason   = 'Resource is outside the capability scope.'
        }
    }

    if (
        $null -ne $Capability.amountLimit
    ) {
        if ($Amount -gt [decimal]$Capability.amountLimit) {
            return [pscustomobject]@{
                Eligible = $false
                Reason   = 'Requested amount exceeds configured capability limit.'
            }
        }
    }

    [pscustomobject]@{
        Eligible = $true
        Reason   = 'Capability constraints satisfied.'
    }
}
