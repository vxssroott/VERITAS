$ErrorActionPreference = 'Stop'

$Module = Join-Path $PSScriptRoot 'src\VERITAS\VERITAS.psd1'

Import-Module $Module -Force

Invoke-VERITAS
