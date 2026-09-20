function Get-VERITASOperatorContext {

    [CmdletBinding()]
    param(
        [string]$InstitutionId
    )

    . "$PSScriptRoot\..\Identity\Resolvers\Resolve-VERITASIdentity.ps1"
    . "$PSScriptRoot\..\Authority\Resolvers\Resolve-VERITASAuthority.ps1"

    $Identity = Resolve-VERITASIdentity

    if (-not $InstitutionId) {
        $InstitutionId = 'UNRESOLVED-INSTITUTION'
    }

    $Authority = Resolve-VERITASAuthority `
        -OperatorId $Identity.IdentityId `
        -InstitutionId $InstitutionId

    [pscustomobject]@{
        Identity  = $Identity
        Authority = $Authority
        ResolvedAt = [DateTime]::UtcNow.ToString('o')
    }
}
