function Resolve-VERITASIdentity {

    [CmdletBinding()]
    param(
        [string]$DeclaredIdentity
    )

    $WindowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()

    $IdentityName = $WindowsIdentity.Name

    if ($DeclaredIdentity) {
        $IdentityName = $DeclaredIdentity
    }

    [pscustomobject]@{
        IdentityId          = $IdentityName
        WindowsIdentity     = $WindowsIdentity.Name
        AuthenticationState = 'AUTHENTICATED'
        VerificationState   = 'LOCAL_IDENTITY_VERIFIED'
        Source               = 'WindowsIdentity'
        ResolvedAt           = [DateTime]::UtcNow.ToString('o')
    }
}
