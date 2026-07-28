param administratorLogin string = ''

@secure()
param administratorLoginPassword string = ''
param collation string
param databaseName string
param tier string
param skuName string
param location string
param maxSizeBytes int
param serverName string
param zoneRedundant bool
param readScaleOut string
param numberOfReplicas int

@description('Flag for enabling vulnerability assessments with express configuration (storage less), the user deploying this template must have administrator or owner permissions.')
param publicNetworkAccess string
param requestedBackupStorageRedundancy string

@description('Microsoft Entra ID of the server.')
param identity object = {}

resource server 'Microsoft.Sql/servers@2021-08-01-preview' = {
  location: location
  name: serverName
  properties: {
    version: '12.0'
    publicNetworkAccess: publicNetworkAccess
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
  identity: identity
}

resource serverName_database 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: server
  location: location
  name: databaseName
  properties: {
    collation: collation
    maxSizeBytes: maxSizeBytes
    zoneRedundant: zoneRedundant
    readScale: readScaleOut
    highAvailabilityReplicaCount: numberOfReplicas
    requestedBackupStorageRedundancy: requestedBackupStorageRedundancy
  }
  sku: {
    name: skuName
    tier: tier
  }
}
