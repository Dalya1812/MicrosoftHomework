Connect-AzAccount
$resourceGroupName = "MyResourceGroup"
$location = "East US"

$vmName = "MyVm"
$vmSize = "Standard_DS2_v2"
$templateFilePath = "./vm_template.json"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath  
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
$vm
