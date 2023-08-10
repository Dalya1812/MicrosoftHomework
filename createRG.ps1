
Connect-AzAccount
# Create a new resource group
$resourceGroupName = "NewResourceGroup"
$location = "westus"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a virtual network
$virtualNetworkName = "myVNet"
$addressPrefix = "10.0.0.0/16"
$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $virtualNetworkName -AddressPrefix $addressPrefix

# Create a subnet
$subnetName = "mySubnet"
$subnetPrefix = "10.0.0.0/24"
Add-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetPrefix -VirtualNetwork $virtualNetwork | Set-AzVirtualNetwork

$resourceGroupName = "NewResourceGroup"
Start-Sleep -Seconds 60