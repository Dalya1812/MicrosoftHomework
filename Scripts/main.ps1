. "/Users/home/Desktop/microsoft/MicrosoftHomework/Scripts/deployment.ps1"
. "/Users/home/Desktop/microsoft/MicrosoftHomework/Scripts/blobsScript.ps1"

$resourceGroupName = "NewResourceGroup"
$containerNameA = "con4"
$containerNameB = "trt554353453"
$numOfBlobs = 3
$accountName = "mysa20230810084143"
$sourceConnectionString = "DefaultEndpointsProtocol=https;AccountName=mysa20230810084143;AccountKey=8qU7TUMwUV5V2HRvK7iom+M6MifTwkqNjBk7DGVHwhezhjftEq95lQqxnJHEjUOml2zl1sA3Ws32+ASt7ufvHg==;EndpointSuffix=core.windows.net"
$targetConnectionString = "DefaultEndpointsProtocol=https;AccountName=mysa20230810084143;AccountKey=8qU7TUMwUV5V2HRvK7iom+M6MifTwkqNjBk7DGVHwhezhjftEq95lQqxnJHEjUOml2zl1sA3Ws32+ASt7ufvHg==;EndpointSuffix=core.windows.net"
$vmName = "mVM"
$scriptFileName = "blobsScript.ps1"
$scriptFilePath = "/Users/home/Desktop/microsoft/MicrosoftHomework/Scripts/blobsScript.ps1"  

#Write-Host "Source Connection String: $sourceConnectionString"
#Write-Host "Target Connection String: $targetConnectionString"

#Create-N-Blobs -numOfBlobs $numOfBlobs -resourceGroupName $resourceGroupName -accountName $accountName -containerName $containerNameA
#Copy-Paste-Blobs -sourceConnectionString $sourceConnectionString `
 #                -targetConnectionString $targetConnectionString `
 #                -sourceContainerName $containerNameA `
 #                -targetContainerName $containerNameB


#$vm = CreateVM -resourceGroupName $resourceGroupName  -vmName $vmName
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $accountName
$storageContext = $storageAccount.Context
Set-AzStorageBlobContent -Context $storageContext -Container $containerNameA -File $scriptFilePath -Blob $scriptFileName
$scriptFileUri = "https://$accountName.blob.core.windows.net/$containerNameA/blobsScript.ps1"
$location = $vm.Location  
Set-AzVMCustomScriptExtension -ResourceGroupName $resourceGroupName -VMName $vmName -Location $location `
                              -Name $scriptFileName -FileUri $scriptFileUri -Run "blobsScript.ps1" `
                         -Argument "-operation 'Create-N-Blobs' -param1 10 -param2 'MyResourceGroup' -param3 'MyStorageAccount' -param4 'MyContainer'"

