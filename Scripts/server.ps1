. "./vm_deployment.ps1"
$resourceGroupName = "NewResourceGroup"
$templateVMFilePath = "./vm_template.json"
$vm = CreateVM -resourceGroupName $resourceGroupName -templateFilePath $templateVMFilePath -vmName $vmName
$vm
