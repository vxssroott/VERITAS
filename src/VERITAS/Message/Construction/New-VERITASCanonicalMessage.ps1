function New-VERITASCanonicalMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [object]$Profile
    )

    $validation =
        Invoke-VERITASTransactionValidation `
            -Transaction $Transaction

    if ($validation.status -ne "VALID") {
        throw (
            "Canonical message construction blocked. " +
            "Validation status: $($validation.status)"
        )
    }

    $fields = [ordered]@{}

    foreach ($field in $Profile.requiredFields) {

        $property =
            $Transaction.transactionData.PSObject.Properties |
            Where-Object {
                $_.Name -eq $field
            }

        if ($null -eq $property) {
            throw "Required message field missing: $field"
        }

        $fields[$field] = $property.Value
    }

    $message = [ordered]@{
        messageId = "MSG-" + [Guid]::NewGuid().ToString().ToUpperInvariant()
        transactionId = $Transaction.transactionId
        transactionVersion = [int]$Transaction.version
        profileId = $Profile.profileId
        standard = $Profile.standard
        messageType = $Profile.messageType
        fields = $fields
        integrity = [ordered]@{
            algorithm = "SHA-256"
            digest = ""
        }
    }

    $canonical =
        $message |
        ConvertTo-Json -Depth 100 -Compress

    $bytes =
        [System.Text.Encoding]::UTF8.GetBytes($canonical)

    $sha =
        [System.Security.Cryptography.SHA256]::Create()

    try {
        $hash = $sha.ComputeHash($bytes)
    }
    finally {
        $sha.Dispose()
    }

    $message.integrity.digest =
        ([System.BitConverter]::ToString($hash) -replace "-", "").ToLowerInvariant()

    return [pscustomobject]$message
}
