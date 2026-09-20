function ConvertTo-VERITASCanonicalJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$InputObject
    )

    if ($null -eq $InputObject) {
        throw "Cannot canonicalize a null transaction object."
    }

    return ($InputObject | ConvertTo-Json -Depth 100 -Compress)
}
