. "./vm_deployment.ps1"
. "./create-N-blobs.ps1"
. "./copy-paste-blobs.ps1"

# Define variables
$resourceGroupName = "NewResourceGroup"
$sourceContainerName = "con3565644"
$targetContainerName = "trt554355"
$storageAccountName = "mysa20230810084143"
$numOfBlobs = 3

$storage1 = Create-StorageAccount -resourceGroupName $resourceGroupName -location $location -sku $sku
$storage2 = Create-StorageAccount -resourceGroupName $resourceGroupName -location $location -sku $sku

Write-Host "Storage 1 Name: $($storage1.StorageAccountName)"
Write-Host "Storage 2 Name: $($storage2.StorageAccountName)"
# Get storage account keys
$sourceStorageAccountKeys = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storage1.StorageAccountName)
$targetStorageAccountKeys = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storage2.StorageAccountName)

$sourceStorageAccountCredential = $sourceStorageAccountKeys[0].Value
$targetStorageAccountCredential = $targetStorageAccountKeys[0].Value

# Create storage account contexts
$sourceStorageAccountContext = New-AzStorageContext -StorageAccountName $storage1.StorageAccountName -StorageAccountKey $sourceStorageAccountCredential
$targetStorageAccountContext = New-AzStorageContext -StorageAccountName $storage2.StorageAccountName -StorageAccountKey $targetStorageAccountCredential

# Create containers
$storageAccountContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName).Context
$container1 = New-AzStorageContainer -Name $sourceContainerName -Context $storageAccountContext
$container2 = New-AzStorageContainer -Name $targetContainerName -Context $storageAccountContext
# Call the functions
Create-N-Blobs -numOfBlobs $numOfBlobs -resourceGroupName $resourceGroupName -storageAccountName $storageAccountName -containerName $sourceContainerName

# Copy-Paste-Blobs (uncomment this after verifying the rest of the script)
Copy-Paste-Blobs -sourceContainerName $sourceContainerName -targetContainerName $targetContainerName -sourceStorageAccountCredential $sourceStorageAccountCredential -targetStorageAccountCredential $targetStorageAccountCredential
