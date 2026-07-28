param networkInterfaceName string
param location string
param subnetRef string
param pipDeleteOption string
param publicIpAddressName string
param publicIpAddressType string
param publicIpAddressSku string
param networkSecurityGroupName string
param networkSecurityGroupRules array
param virtualMachineName string
param virtualMachineSize string
param osDiskType string
param osDiskDeleteOption string
param nicDeleteOption string
param securityType string
param secureBoot bool
param vTPM bool
param virtualMachineComputerName string
param adminUsername string
@secure()
param adminPassword string
param patchMode string
param enablePeriodicAssessment string
param enableHotpatching bool
param hibernationEnabled bool

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
      id: networkSecurityGroup.id
    }
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

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: networkSecurityGroupRules
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
}
