function Create-N-Blobs {
    param (
        [int]$numOfBlobs,
        [string]$resourceGroupName,
        [string]$accountName,
        [string]$containerName
    )
    
    $sourceContext = New-AzStorageContext -ConnectionString (az storage account show-connection-string --name $accountName --resource-group $resourceGroupName --query connectionString --output tsv)

    for ($i = 1; $i -le $numOfBlobs; $i++) {
        $blobName = "blob$i.txt"
        $blobContent = "This is blob content $i"
        $tempDirectory = $env:TMPDIR
        $tempFilePath = Join-Path $tempDirectory $blobName
        Set-AzStorageBlobContent -Container $containerName -Blob $blobName -File $tempFilePath -Context $sourceContext
    }
}

function Copy-Paste-Blobs {
    param (
        [string]$sourceConnectionString,
        [string]$targetConnectionString,
        [string]$sourceContainerName,
        [string]$targetContainerName
    )

    $sourceContext = New-AzStorageContext -ConnectionString $sourceConnectionString
    $targetContext = New-AzStorageContext -ConnectionString $targetConnectionString
    Write-Host "Container Name A: $sourceContainerName"
    Write-Host "Container Name B: $targetContainerName"

    $blobs = Get-AzStorageBlob -Container $sourceContainerName -Context $sourceContext

    foreach ($blob in $blobs) {
        $sourceBlobName = $blob.Name
        $targetBlobName = $sourceBlobName 

        $copyResult = Start-AzStorageBlobCopy -SrcBlob $sourceBlobName -SrcContainer $sourceContainerName `
                                              -DestBlob $targetBlobName -DestContainer $targetContainerName `
                                              -Context $targetContext

        Write-Host "Copying blob '$sourceBlobName' to '$targetContainerName/$targetBlobName'. Copy status: $($copyResult.Status)"
    }
}


