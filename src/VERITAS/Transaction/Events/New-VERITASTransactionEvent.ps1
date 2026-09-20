function New-VERITASTransactionEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Transaction,

        [Parameter(Mandatory)]
        [string]$EventType,

        [Parameter(Mandatory)]
        [string]$Actor,

        [hashtable]$Data = @{}
    )

    $event = [ordered]@{
        eventId = [Guid]::NewGuid().ToString()
        eventType = $EventType
        transactionId = $Transaction.transactionId
        transactionVersion = [int]$Transaction.version
        transactionState = $Transaction.state
        actor = $Actor
        occurredAt = [DateTime]::UtcNow.ToString("o")
        data = $Data
    }

    $eventJson = $event | ConvertTo-Json -Depth 100 -Compress

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($eventJson)
    $sha = [System.Security.Cryptography.SHA256]::Create()

    try {
        $eventHash = $sha.ComputeHash($bytes)
    }
    finally {
        $sha.Dispose()
    }

    $event.hash = ([System.BitConverter]::ToString($eventHash) -replace "-", "").ToLowerInvariant()

    return [pscustomobject]$event
}
