function Resolve-VERITASAuthority {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OperatorId,

        [Parameter(Mandatory = $true)]
        [string]$InstitutionId
    )

    $AuthorityConfig = Join-Path `
        $PSScriptRoot `
        '..\..\..\..\..\config\authority\assignments.json'

    if (-not (Test-Path $AuthorityConfig)) {

        return [pscustomobject]@{
            OperatorId       = $OperatorId
            InstitutionId    = $InstitutionId
            ResolutionState  = 'UNRESOLVED'
            AuthorityState   = 'NOT_CONFIGURED'
            RoleId           = $null
            AuthorityProfile = $null
            Source           = $null
            Reason           = 'No authoritative institutional authority source is configured.'
        }
    }

    $Assignments = Get-Content `
        $AuthorityConfig `
        -Raw | ConvertFrom-Json

    $Assignment = @(
        $Assignments.assignments |
        Where-Object {
            $_.operatorId -eq $OperatorId -and
            $_.institutionId -eq $InstitutionId
        }
    )

    if ($Assignment.Count -eq 0) {

        return [pscustomobject]@{
            OperatorId       = $OperatorId
            InstitutionId    = $InstitutionId
            ResolutionState  = 'UNRESOLVED'
            AuthorityState   = 'NOT_ASSIGNED'
            RoleId           = $null
            AuthorityProfile = $null
            Source            = 'InstitutionAuthorityRegistry'
            Reason           = 'No authoritative assignment exists for this identity.'
        }
    }

    if ($Assignment.Count -gt 1) {

        return [pscustomobject]@{
            OperatorId       = $OperatorId
            InstitutionId    = $InstitutionId
            ResolutionState  = 'AMBIGUOUS'
            AuthorityState   = 'NOT_RESOLVED'
            RoleId           = $null
            AuthorityProfile = $null
            Source            = 'InstitutionAuthorityRegistry'
            Reason           = 'Multiple conflicting authority assignments were discovered.'
        }
    }

    $Resolved = $Assignment[0]

    [pscustomobject]@{
        OperatorId       = $OperatorId
        InstitutionId    = $InstitutionId
        ResolutionState  = 'RESOLVED'
        AuthorityState   = $Resolved.status
        RoleId           = $Resolved.roleId
        AuthorityProfile = $Resolved.authorityProfileId
        Source            = 'InstitutionAuthorityRegistry'
        Reason           = 'Authority resolved from configured institutional source.'
    }
}
