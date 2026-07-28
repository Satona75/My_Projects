param location string
param subnetName string
param pipDeleteOption string
param publicIpAddressName string
param publicIpAddressType string
param publicIpAddressSku string
param networkInterfaceName string
param networkSecurityGroupName string
param networkSecurityGroupRules array
param virtualMachineName string
param virtualMachineComputerName string
param virtualMachineSize string
param osDiskType string
param osDiskDeleteOption string
param nicDeleteOption string
param securityType string
param secureBoot bool
param vTPM bool
param adminUsername string

@secure()
param adminPassword string
param patchMode string
param enablePeriodicAssessment string
param enableHotpatching bool
param hibernationEnabled bool

@description('Azure region for the deployment, resource group and resources.')
param vnetLocation string
param vnetExtendedLocation object

@description('Name of the virtual network resource.')
param vnetVirtualNetworkName string = 'myVnet'

@description('Optional tags for the resources.')
param vnetTagsByResource object = {}

@description('The properties of the virtual network')
param vnetProperties object = {}
param vnetNatGatewaysWithNewPublicIpAddress array
param vnetNatGatewaysWithoutNewPublicIpAddress array

@description('Array of public ip addresses for NAT Gateways.')
param vnetNatGatewayPublicIpAddressesNewNames array

@description('Array of network security group objects.')
param vnetNetworkSecurityGroupsNew array

@description('Name of the vnet\'s containing resource group.')
param vnetResourceGroupName string

@description('Name of the vnet deployment.')
param vnetDeploymentName string

var subnetRef = '/subscriptions/88888d09-c09d-4578-ab0d-731f655d24ef/resourceGroups/monitoring_rg/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-1/subnets/${subnetName}'
var nsgId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var standardSku = {
  name: 'Standard'
}
var vnetStaticAllocation = {
  publicIPAllocationMethod: 'Static'
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          primary: true
          publicIPAddress: {
            id: publicIpAddress.id
            properties: {
              deleteOption: pipDeleteOption
            }
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    networkSecurityGroup
    vnetDeployment
  ]
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: networkSecurityGroupRules
  }
}

resource publicIpAddress 'Microsoft.Network/publicIpAddresses@2023-06-01' = {
  name: publicIpAddressName
  location: location
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
  sku: {
    name: publicIpAddressSku
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
        deleteOption: osDiskDeleteOption
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
          properties: {
            deleteOption: nicDeleteOption
          }
        }
      ]
    }
    securityProfile: {
      securityType: securityType
      uefiSettings: {
        secureBootEnabled: secureBoot
        vTpmEnabled: vTPM
      }
    }
    osProfile: {
      computerName: virtualMachineComputerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          patchMode: patchMode
          assessmentMode: enablePeriodicAssessment
          enableHotpatching: enableHotpatching
        }
      }
    }
    additionalCapabilities: {
      hibernationEnabled: hibernationEnabled
    }
  }
  dependsOn: [
    vnetDeployment
  ]
}

module vnetDeployment 'Modules/nested_vnetDeployment.bicep' = {
  name: vnetDeploymentName
  scope: resourceGroup(vnetResourceGroupName)
  params: {
    vnetVirtualNetworkName: vnetVirtualNetworkName
    vnetLocation: vnetLocation
    vnetExtendedLocation: vnetExtendedLocation
    vnetTagsByResource: vnetTagsByResource
    vnetProperties: vnetProperties
  }
  dependsOn: [
    vnetNatGatewaysWithNewPublicIpAddress_name
    vnetNatGatewaysWithoutNewPublicIpAddress_name
    vnetNetworkSecurityGroupsNew_name
    vnetNatGatewayPublicIpAddressesNewNames_resource
    vnetNatGatewayPublicIpAddressesNewNames_resource
  ]
}

resource vnetNatGatewaysWithoutNewPublicIpAddress_name 'Microsoft.Network/natGateways@2020-11-01' = [
  for item in vnetNatGatewaysWithoutNewPublicIpAddress: if (length(vnetNatGatewaysWithoutNewPublicIpAddress) > 0) {
    name: item.name
    location: vnetLocation
    sku: standardSku
    properties: item.properties
  }
]

resource vnetNatGatewaysWithNewPublicIpAddress_name 'Microsoft.Network/natGateways@2020-11-01' = [
  for item in vnetNatGatewaysWithNewPublicIpAddress: if (length(vnetNatGatewaysWithNewPublicIpAddress) > 0) {
    name: item.name
    location: vnetLocation
    sku: standardSku
    properties: item.properties
    dependsOn: [
      vnetNatGatewayPublicIpAddressesNewNames_resource
    ]
  }
]

resource vnetNatGatewayPublicIpAddressesNewNames_resource 'Microsoft.Network/publicIpAddresses@2020-11-01' = [
  for item in vnetNatGatewayPublicIpAddressesNewNames: if (length(vnetNatGatewayPublicIpAddressesNewNames) > 0) {
    name: item
    location: vnetLocation
    sku: standardSku
    properties: vnetStaticAllocation
  }
]

resource vnetNetworkSecurityGroupsNew_name 'Microsoft.Network/networkSecurityGroups@2020-11-01' = [
  for item in vnetNetworkSecurityGroupsNew: if (length(vnetNetworkSecurityGroupsNew) > 0) {
    name: item.name
    location: vnetLocation
    properties: {}
  }
]
