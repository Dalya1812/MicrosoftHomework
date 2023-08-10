Connect-AzAccount
$location = "East US"
$resourceGroupName = "NewResourceGroup"
$sku = "Standard_LRS"


function Create-ResourceGroup{
    param (
        [string]$resourceGroupName,
        [string]$location,
        [string]$sku
    )
    $templateFilePath ="./vm_template.json"
    $deployment =New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -vmName "myNewVM"
    $deploymentName = $deployment.DeploymentName
    $deployment.ProvisioningState
    $deployment.Error
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



Create-StorageAccount -resourceGroupName $resourceGroupName -location $location -sku $sku


