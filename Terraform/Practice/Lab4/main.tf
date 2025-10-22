resource "azurerm_resource_group" "network"{
  name = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.93.0.0/22"]
}

//10.93.0.0/24
resource "azurerm_subnet" "alpha" {
  name                 = "snet-alpha"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.93.0.0/24"]
}

//10.93.1.0/24
resource "azurerm_subnet" "beta" {
  name                 = "snet-beta"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.93.1.0/24"]
}

//10.93.2.0/24
resource "azurerm_subnet" "charlie" {
  name                 = "snet-charlie"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.93.2.0/24"]
}

//10.93.3.0/24
resource "azurerm_subnet" "delta" {
  name                 = "snet-delta"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.93.3.0/24"]
}