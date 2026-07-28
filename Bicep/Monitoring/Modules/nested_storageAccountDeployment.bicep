param location string
param storageAccountName string
param accountType string
param kind string

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: accountType
  }
  kind: kind
}
