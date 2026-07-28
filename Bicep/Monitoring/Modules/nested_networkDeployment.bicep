@description('Name of the virtual network resource.')
param vnetVirtualNetworkName string

@description('Azure region for the deployment, resource group and resources.')
param vnetLocation string

@description('The properties of the virtual network')
param vnetProperties object

resource vnetVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetVirtualNetworkName
  location: vnetLocation
  properties: vnetProperties
}

output subnetid string = vnetVirtualNetwork.properties.subnets[0].id
