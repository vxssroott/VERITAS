function ConvertTo-VERITASMessagePreview {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Message
    )

    return [pscustomobject]@{
        messageId = $Message.messageId
        transactionId = $Message.transactionId
        transactionVersion = $Message.transactionVersion
        profileId = $Message.profileId
        standard = $Message.standard
        messageType = $Message.messageType
        fields = $Message.fields
        transmissionPerformed = $false
        externalDeliveryObserved = $false
    }
}
