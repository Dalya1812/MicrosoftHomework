. "./vm_deployment.ps1"
$templateVMFilePath ="./vm_template.json"
$resourceGroupName = "NewResourceGroup"
$vmName= "mVM"
$location = "East US"
$sku = "Standard_LRS"


$vm = CreateVM -resourceGroupName $resourceGroupName -templateFilePath $templateVMFilePath -vmName $vmName
$stroage1=Create-StorageAccount -resourceGroupName $resourceGroupName -location $location -sku $sku
$stroage2=Create-StorageAccount -resourceGroupName $resourceGroupName -location $location -sku $sku

