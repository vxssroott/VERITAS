function New-VERITASTransactionId {
    [CmdletBinding()]
    param(
        [string]$Prefix = "TX"
    )

    $timestamp = [DateTime]::UtcNow.ToString("yyyyMMddHHmmssfff")
    $random = [Guid]::NewGuid().ToString("N").Substring(0, 8).ToUpperInvariant()

    return "$Prefix-$timestamp-$random"
}
