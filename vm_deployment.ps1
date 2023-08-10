Connect-AzAccount

#$templateFilePath= "./vm_template.json"
#$deployment =New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -vmName "myNewVM"
#$deploymentName = $deployment.DeploymentName
#$deployment.ProvisioningState
#$deployment.Error


$templateFilePath= "./storage_account_template.json"
$storageAccountName = "mystor5435345"
$resourceGroupName = "NewResourceGroup"
$location = "East US"
$sku = "Standard_LRS"

New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Location $location -SkuName $sku
$deployment.ProvisioningState
$deployment.Error


