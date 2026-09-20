function Invoke-VERITASPolicyEvaluation {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Operation,

        [Parameter(Mandatory = $true)]
        [string]$InstitutionId,

        [string]$Environment = 'DEVELOPMENT',

        [string]$TransactionType,

        [decimal]$Amount = 0
    )

    $RegistryPath = Join-Path `
        $PSScriptRoot `
        '..\..\..\..\..\config\policy\registry.json'

    if (-not (Test-Path $RegistryPath)) {

        return [pscustomobject]@{
            Decision = 'UNRESOLVED'
            Reason   = 'Policy registry unavailable.'
        }
    }

    $Registry = Get-Content `
        $RegistryPath `
        -Raw | ConvertFrom-Json

    $ApplicablePolicies = @(
        $Registry.policySets |
        Where-Object {
            $_.institutionId -eq $InstitutionId -and
            $_.status -eq 'ACTIVE' -and
            (
                $_.environments.Count -eq 0 -or
                $_.environments -contains $Environment
            )
        }
    )

    if ($ApplicablePolicies.Count -eq 0) {

        return [pscustomobject]@{
            Decision = 'UNRESOLVED'
            Reason   = 'No applicable institutional policy set is configured.'
        }
    }

    foreach ($PolicySet in $ApplicablePolicies) {

        foreach ($Rule in $PolicySet.rules) {

            if (
                $Rule.operation -eq $Operation -and
                (
                    -not $Rule.transactionType -or
                    $Rule.transactionType -eq $TransactionType
                )
            ) {

                if (
                    $null -ne $Rule.maxAmount -and
                    $Amount -gt [decimal]$Rule.maxAmount
                ) {

                    return [pscustomobject]@{
                        Decision = 'DENY'
                        PolicySet = $PolicySet.id
                        Rule      = $Rule.id
                        Reason    = 'Configured policy amount constraint exceeded.'
                    }
                }

                if ($Rule.decision) {

                    return [pscustomobject]@{
                        Decision  = $Rule.decision
                        PolicySet = $PolicySet.id
                        Rule      = $Rule.id
                        Reason    = $Rule.reason
                    }
                }
            }
        }
    }

    [pscustomobject]@{
        Decision = 'UNRESOLVED'
        Reason   = 'No applicable rule produced a decision.'
    }
}
