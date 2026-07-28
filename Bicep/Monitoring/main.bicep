param location string
param resourceGroupName string
param publicIpAddressName string
param pipDeleteOption string
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
param sqlAdministratorLogin string
param storageAccountName string
param storageAccountType string
param storageAccountKind string
param collation string
param databaseName string
param sqlTier string
param sqlSkuName string
param maxSizeBytes int
param sqlServerName string
param readScaleOut string
param numberOfReplicas int
param zoneRedundant bool
param identity object
param sqlPublicNetworkAccess string
param sqlRequestedBackupStorageRedundancy string

param patchMode string
param enablePeriodicAssessment string
param enableHotpatching bool
param hibernationEnabled bool

@secure()
param adminPassword string
@secure()
param sqlAdministratorPassword string

@description('Name of the virtual network resource.')
param vnetVirtualNetworkName string = 'myVnet'

@description('The properties of the virtual network')
param vnetProperties object = {}

// Get reference of Resource Group

// Deployment of Network dependancies - Virtual Network, Subnet

module netDeployment 'Modules/nested_networkDeployment.bicep' = {
  name: 'vnetDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    vnetVirtualNetworkName: vnetVirtualNetworkName
    vnetLocation: location
    vnetProperties: vnetProperties
  }
}

// Deployment of the Virtual Machine and its dependencies

module vmDeployment 'Modules/nested_virtualMachine.bicep' = {
  name: 'vmDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    networkInterfaceName: networkInterfaceName
    location: location
    subnetRef: netDeployment.outputs.subnetid
    pipDeleteOption: pipDeleteOption
    publicIpAddressName: publicIpAddressName
    publicIpAddressType: publicIpAddressType
    publicIpAddressSku: publicIpAddressSku
    networkSecurityGroupName: networkSecurityGroupName
    networkSecurityGroupRules: networkSecurityGroupRules
    virtualMachineName: virtualMachineName
    virtualMachineSize: virtualMachineSize
    osDiskType: osDiskType
    osDiskDeleteOption: osDiskDeleteOption
    nicDeleteOption: nicDeleteOption
    securityType: securityType
    secureBoot: secureBoot
    vTPM: vTPM
    virtualMachineComputerName: virtualMachineComputerName
    adminUsername: adminUsername
    adminPassword: adminPassword
    patchMode: patchMode
    enablePeriodicAssessment: enablePeriodicAssessment
    enableHotpatching: enableHotpatching
    hibernationEnabled: hibernationEnabled
  }
}

// Deployment of Storage Account

module saDeployment 'Modules/nested_storageAccountDeployment.bicep' = {
  name: 'saDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    storageAccountName: storageAccountName
    accountType: storageAccountType
    kind: storageAccountKind
  }
}

// Deployment of Azure SQL Database

module sqlDeployment 'Modules/nested_sqlServerDeployment.bicep' = {
  name: 'sqlDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorPassword
    collation: collation
    databaseName: databaseName
    tier: sqlTier
    skuName: sqlSkuName
    location: location
    maxSizeBytes: maxSizeBytes
    serverName: sqlServerName
    zoneRedundant: zoneRedundant
    readScaleOut: readScaleOut
    numberOfReplicas: numberOfReplicas
    identity: identity
    publicNetworkAccess: sqlPublicNetworkAccess
    requestedBackupStorageRedundancy: sqlRequestedBackupStorageRedundancy
  }
}
