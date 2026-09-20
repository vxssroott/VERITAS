function Get-VERITASAuthorizationState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction
    )

    switch ($Transaction.state) {

        "AUTHORIZED" {
            return [pscustomobject]@{
                state = "AUTHORIZED"
                executionAuthorized = $false
                executionConsent = $false
                meaning = "Workflow authorization state reached. Explicit execution consent remains required."
            }
        }

        "EXECUTION_ELIGIBLE" {
            return [pscustomobject]@{
                state = "EXECUTION_ELIGIBLE"
                executionAuthorized = $false
                executionConsent = $false
                meaning = "Configured execution prerequisites are satisfied. Explicit execution consent remains required."
            }
        }

        "CONSENT_REQUIRED" {
            return [pscustomobject]@{
                state = "CONSENT_REQUIRED"
                executionAuthorized = $false
                executionConsent = $false
                meaning = "Execution consent must be explicitly obtained."
            }
        }

        default {
            return [pscustomobject]@{
                state = $Transaction.state
                executionAuthorized = $false
                executionConsent = $false
                meaning = "Transaction is not in an execution authorization state."
            }
        }
    }
}
