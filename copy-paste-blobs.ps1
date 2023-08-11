function Copy-Paste-Blobs{
param(
    [string] $sourceStorageAccountName,
    [string] $targetStorageAccountName,
    [string] $sourceContainerName,
    [string] $targetContainerName,
    [string] $sourceStorageAccountCredential,
    [string] $targetStorageAccountCredential
)

    $targetStorageAccountContext = (New-AzStorageContext -StorageAccountName $targetStorageAccountName -StorageAccountKey $targetStorageAccountKey).Context
    $sourceStorageAccountContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName).Context
$blobs = Get-AzStorageBlob -Container $sourceContainerName -Context $sourceStorageAccountContext
foreach ($blob in $blobs) {
    $sourceBlobName = $blob.Name
    $targetBlobName = $sourceBlobName 
    $copyResult = Start-AzStorageBlobCopy -Context $sourceStorageAccountContext -SrcContainer $sourceContainerName -SrcBlob $sourceBlobName `
                                          -DestContext $targetStorageAccountContext -DestContainer $targetContainerName -DestBlob $targetBlobName

    if ($copyResult.Error) {
        Write-Host ("Error copying blob {0}: {1}" -f $sourceBlobName, $copyResult.Error)
    } else {
        Write-Host "Blob $sourceBlobName copied successfully."
    }
}
}
