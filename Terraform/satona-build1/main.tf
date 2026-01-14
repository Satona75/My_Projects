resource "azurerm_resource_group" "build1_rg" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.location
}

moved {
  from = azurerm_resource_group.build1
  to   = azurerm_resource_group.build1_rg
}

resource "azurerm_virtual_network" "build1_vnet" {
  name                = "vnet-${var.application_name}-${var.environment_name}"
  address_space       = [var.ip_address]
  location            = azurerm_resource_group.build1_rg.location
  resource_group_name = azurerm_resource_group.build1_rg.name
}

resource "azurerm_subnet" "build1_subnet" {
  name                 = "subnet-${var.application_name}-${var.environment_name}"
  resource_group_name  = azurerm_resource_group.build1_rg.name
  virtual_network_name = azurerm_virtual_network.build1_vnet.name
  address_prefixes     = [var.subnet_address]
}

resource "azurerm_network_interface" "build1_nic" {
  name                = "nic-vm-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.build1_rg.location
  resource_group_name = azurerm_resource_group.build1_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.build1_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "build1_vm" {
  name                = "vm-${var.application_name}-${var.environment_name}"
  resource_group_name = azurerm_resource_group.build1_rg.name
  location            = azurerm_resource_group.build1_rg.location
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
