@{
    RootModule        = 'VERITAS.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '8e9d8e1e-5a58-4c1d-9e9b-1a2b3c4d5e6f'
    Author            = 'VERITAS'
    CompanyName       = 'VERITAS'
    Description       = 'Verified Execution, Reconciliation & Integrated Transaction Assurance System'
    PowerShellVersion = '5.1'

    FunctionsToExport = @(
        'Invoke-VERITAS',
        'Get-VERITASStatus',
        'Get-VERITASTransaction',
        'New-VERITASTransaction',
        'Review-VERITASTransaction',
        'Invoke-VERITASConsent'
    )
}
