function Resolve-VERITASCapabilities {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OperatorId,

        [Parameter(Mandatory = $true)]
        [string]$InstitutionId,

        [Parameter(Mandatory = $true)]
        [string]$AuthorityProfileId,

        [string]$Environment = 'DEVELOPMENT'
    )

    $RegistryPath = Join-Path `
        $PSScriptRoot `
        '..\..\..\..\..\config\capabilities\registry.json'

    if (-not (Test-Path $RegistryPath)) {

        return [pscustomobject]@{
            State        = 'UNRESOLVED'
            OperatorId   = $OperatorId
            InstitutionId = $InstitutionId
            Capabilities = @()
            Reason       = 'Capability registry is unavailable.'
        }
    }

    $Registry = Get-Content `
        $RegistryPath `
        -Raw | ConvertFrom-Json

    $Matches = @(
        $Registry.capabilities |
        Where-Object {

            $_.institutionId -eq $InstitutionId -and
            $_.authorityProfileId -eq $AuthorityProfileId -and
            $_.status -eq 'ACTIVE' -and
            (
                $_.environments.Count -eq 0 -or
                $_.environments -contains $Environment
            )
        }
    )

    if ($Matches.Count -eq 0) {

        return [pscustomobject]@{
            State         = 'RESOLVED'
            OperatorId    = $OperatorId
            InstitutionId = $InstitutionId
            AuthorityProfileId = $AuthorityProfileId
            Capabilities  = @()
            Reason        = 'No matching capabilities are configured.'
        }
    }

    [pscustomobject]@{
        State         = 'RESOLVED'
        OperatorId    = $OperatorId
        InstitutionId = $InstitutionId
        AuthorityProfileId = $AuthorityProfileId
        Capabilities  = @($Matches)
        Reason        = 'Capabilities resolved from configured registry.'
    }
}
