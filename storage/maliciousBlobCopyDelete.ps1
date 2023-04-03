param($eventGridEvent, $TriggerMetadata)

# Make sure to pass hashtables to Out-String so they're logged correctly
$eventGridEvent | ConvertTo-JSON -Depth 5 | Out-String | Write-Host

$scanResult = $eventGridEvent.data.scanResultType
$blobUri = $eventGridEvent.data.blobUri

# use this for testing
#$blobUri = "https://dmsstorageacct1.blob.core.windows.net/malware/eicar.com.txt"
$storageAccountName = (($blobUri -split "//")[1] -split "\.")[0]
$malwareContainerName = ($blobUri -split "/")[-2]
$malwareBlobName = ($blobUri -split "/")[-1]

# Set the container names
$quarantineContainerName = "quarantine"

# Create a new Azure storage context using the account details
$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount

# Check the scan result
$scanResult = "Malicious"

if ($scanResult -eq "Malicious") {
    #write host
    Write-Host "$storageAccountName, $malwareContainerName, $malwareBlobName, $stroageContext, $scanResult"
    
    # Get the malware blob
    $malwareBlob = Get-AzStorageBlob -Context $storageContext -Container $malwareContainerName -Blob $malwareBlobName -IncludeTag

    # Copy the malware blob to the quarantine container
    $quarantineBlobName = $malwareBlobName
    Write-Host = $quarantineBlobName
    #Start-AzStorageBlobCopy -Context $storageContext -SrcContainer $malwareContainerName -SrcBlob $malwarceBlobName -DestContainer $quarantineContainerName -DestBlob $quarantineBlobName -Force
    Copy-AzStorageBlob -Context $storageContext -SrcContainer $malwareContainerName -SrcBlob $malwareBlob.Name -DestContainer $quarantineContainerName -DestBlob $quarantineBlobName -Force

    # Delete the malware blob from the malware container
    Remove-AzStorageBlob -Context $storageContext -Container $malwareContainerName -Blob $malwareBlobName
}