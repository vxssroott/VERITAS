function New-VERITASWorkflowEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [string]$ActionId,

        [Parameter(Mandatory)]
        [string]$Actor,

        [Parameter(Mandatory)]
        [string]$Result
    )

    $event = [ordered]@{
        eventId = [Guid]::NewGuid().ToString()
        eventType = "WORKFLOW_ACTION"
        transactionId = $Transaction.transactionId
        transactionVersion = [int]$Transaction.version
        transactionState = $Transaction.state
        actionId = $ActionId
        actor = $Actor
        result = $Result
        occurredAt = [DateTime]::UtcNow.ToString("o")
    }

    $json =
        $event |
        ConvertTo-Json -Depth 100 -Compress

    $bytes =
        [System.Text.Encoding]::UTF8.GetBytes($json)

    $sha =
        [System.Security.Cryptography.SHA256]::Create()

    try {
        $hash = $sha.ComputeHash($bytes)
    }
    finally {
        $sha.Dispose()
    }

    $event.hash =
        ([System.BitConverter]::ToString($hash) -replace "-", "").ToLowerInvariant()

    return [pscustomobject]$event
}
