data "azurerm_resource_group" "azuremrg" {
  name                = "resourcegroupname"
}
resource "azurerm_storage_account" "azuremstoragedemo" {
  name                     = "examplestoragedemo"
  resource_group_name      = data.azurerm_resource_group.azuremrg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
  }

  tags = {
    environment = "staging"
  }

}
resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.azuremrg.name
  virtual_network_name = azurerm_virtual_network.azuremVNet.name
  address_prefixes     = var.address_prefixes
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}
resource "azurerm_virtual_network" "azuremVNet" {
  name                     = "exampleVNet"
  resource_group_name      = data.azurerm_resource_group.azuremrg.name
  location                 = var.location
  address_space       = var.address_space
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azuremrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = data.azurerm_resource_group.azuremrg.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "*******"
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
