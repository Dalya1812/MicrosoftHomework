. "./vm_deployment.ps1"
# Define variables
$templateVMFilePath = "./vm_template.json"
$resourceGroupName = "NewResourceGroup"
$vmName = "mVM"
$location = "East US"
$sku = "Standard_LRS"

# $vm = CreateVM -resourceGroupName $resourceGroupName -templateFilePath $templateVMFilePath -vmName $vmName
$storage1 = Create-StorageAccount -resourceGroupName $resourceGroupName -location $location -sku $sku
$storage2 = Create-StorageAccount -resourceGroupName $resourceGroupName -location $location -sku $sku

$numOfBlobs = 3
$containerName1 = "con352223" 
$containerName2 = "con4533245" 
$storageAccountName = "mysa20230810084143"
$storageAccountContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName).Context
$container1 = New-AzStorageContainer -Name $containerName1 -Context $storageAccountContext
$container2 = New-AzStorageContainer -Name $containerName2 -Context $storageAccountContext

#create and save blobs to the source container
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

# Create blobs in the source container
Create-N-Blobs -numOfBlobs $numOfBlobs -resourceGroupName $resourceGroupName -storageAccountName $storageAccountName -containerName $containerName1

# Copy blobs from source container to target container
function Copy-Paste-Blobs {
    param(
        [string] $sourceStorageAccountName,
        [string] $targetStorageAccountName,
        [string] $sourceContainerName,
        [string] $targetContainerName
    )

    $sourceStorageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $sourceStorageAccountName
    $sourceStorageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $sourceStorageAccountName).Value[0]
    $targetStorageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $targetStorageAccountName
    $targetStorageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $targetStorageAccountName).Value[0]

    # Output the value of sourceStorageAccountContext
    $targetStorageAccountContext = (New-AzStorageContext -StorageAccountName $targetStorageAccountName -StorageAccountKey $targetStorageAccountKey).Context
    $sourceStorageAccountContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName).Context
    $blobs = Get-AzStorageBlob -Container $sourceContainerName -Context $sourceStorageAccountContext
    foreach ($blob in $blobs) {
    $sourceBlobName = $blob.Name
    $targetBlobName = $sourceBlobName 

    # Start the blob copy operation        
    $copyResult = Start-AzStorageBlobCopy -SrcBlob $sourceBlobName -SrcContainer $sourceContainerName `
                                          -DestBlob $targetBlobName -DestContainer $targetContainerName `
                                          -Context $sourceStorageAccountContext


}
}

# Copy blobs from source to target container
Copy-Paste-Blobs -sourceStorageAccountName $storage1.StorageAccountName -targetStorageAccountName $storage2.StorageAccountName -sourceContainerName $containerName1 -targetContainerName $containerName2
