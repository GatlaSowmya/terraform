provider "azurerm" {
  features {}


  subscription_id    = "fadaacfa-db50-4251-b3b9-c1c5838955a2"
  client_id       = "7775287e-0225-4d67-bfe6-2b8f92418e7b"
  client_secret  = "w4d8Q~8JXeypykBDOhYSkYnGHoyapFOsHHdFSa9R"
  tenant_id       = "d2880c00-328c-4e70-9a96-c2298a2745b0"

}

resource "azurerm_resource_group" "rgmine" {
  name     = "rgmine"
  location = "west us"
}

resource "azurerm_virtual_network" "sowmya" {
  name                = "example-vnet18"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rgmine.location
  resource_group_name = azurerm_resource_group.rgmine.name
}

resource "azurerm_subnet" "example18" {
  name                 = "example-subnet18"
  resource_group_name  = azurerm_resource_group.rgmine.name
  virtual_network_name = azurerm_virtual_network.sowmya.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_interface" "example18" {
  name                = "example-nic"
  location            = azurerm_resource_group.rgmine.location
  resource_group_name = azurerm_resource_group.rgmine.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example18.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  admin_username        = "sarala"
  admin_password        = "sarala@12345"
  location              = azurerm_resource_group.rgmine.location
  resource_group_name   = azurerm_resource_group.rgmine.name
  network_interface_ids = [azurerm_network_interface.example18.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

}
