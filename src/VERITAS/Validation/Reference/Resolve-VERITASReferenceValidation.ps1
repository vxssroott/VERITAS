function Resolve-VERITASReferenceValidation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction
    )

    # Phase 6 intentionally does not claim that external
    # institutions/accounts/BICs actually exist.
    #
    # Structural validity is different from authoritative
    # reference verification.

    return [pscustomobject]@{
        status = "UNVERIFIED"
        authoritativeVerificationPerformed = $false
        reason = "No authoritative external reference source has been connected."
    }
}
