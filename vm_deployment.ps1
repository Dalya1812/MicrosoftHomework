Connect-AzAccount
$location = "East US"
$resourceGroupName = "NewResourceGroup"
$sku = "Standard_LRS"


function CreateVM{
    param (
         [string]$resourceGroupName,
       [string]$templateFilePath,
       [string]$vmName

    )
    $templateFilePath ="./vm_template.json"
    $vm =New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -vmName "mVM"
    $vm.ProvisioningState
    $vm.Error
}



function Create-StorageAccount {
    param (
        [string]$resourceGroupName,
        [string]$location,
        [string]$sku
    )
    $templateFilePath = "./storage_account_template.json"
    $storageAccountName = "mysa" + (Get-Date -Format "yyyyMMddHHmmss")
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Location $location -SkuName $sku
}

#Create-StorageAccount -resourceGroupName $resourceGroupName -location $location -sku $sku






