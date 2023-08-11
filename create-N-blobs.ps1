function Create-N-Blobs {
    param (
        [int] $numOfBlobs,
        [string] $resourceGroupName,
        [string] $storageAccountName,
        [string] $containerName
    )

        $storageAccountContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName).Context
        for ($i = 1; $i -le $numOfBlobs; $i++) {
        $blobName = "blob$i.txt"
        $blobContent = "This is the content of blob $i."
        $tempDirectory = $env:TMPDIR
        $tempFilePath = Join-Path $tempDirectory $blobName
        Write-Host "Temporary file path: $tempFilePath"
        $blobContent | Set-Content -Path $tempFilePath -Force
    
        Start-Sleep -Seconds 2 
        Set-AzStorageBlobContent -Container $containerName -Blob $blobName -Context $storageAccountContext -File $tempFilePath
    }
}

function Copy-Paste-Blobs {
    param (
        [string] $sourceContainerName,
        [string] $targetContainerName,
        [string] $sourceStorageAccountName,
        [string] $sourceStorageAccountKey,
        [string] $targetStorageAccountName,
        [string] $targetStorageAccountKey
    )

    $sourceContext = New-AzStorageContext -StorageAccountName $sourceStorageAccountName -StorageAccountKey $sourceStorageAccountKey
    $targetContext = New-AzStorageContext -StorageAccountName $targetStorageAccountName -StorageAccountKey $targetStorageAccountKey

    $blobs = Get-AzStorageBlob -Container $sourceContainerName -Context $sourceContext

    foreach ($blob in $blobs) {
        $blobName = $blob.Name
        Start-AzStorageBlobCopy -SrcBlob $blobName -SrcContainer $sourceContainerName -Context $sourceContext -DestContainer $targetContainerName -Context $targetContext
    }
}

