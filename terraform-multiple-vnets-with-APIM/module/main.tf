//VNETS CANNOT have the same address space
provider "azurerm" {
  features {}
}
data "azurerm_resource_group" "example" {
  name     = "ResourceGroupName"
}

resource "azurerm_virtual_network" "example-1" {
  name                = "VNET-1-dont-use-subnets"
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]
  location            = "East US"
}
resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = data.azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example-1.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
}
resource "azurerm_virtual_network" "example-2" {
  name                = "VNET-2-dont-use-subnets"
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.2.0.0/16"]
  location            = "East US"
}
resource "azurerm_subnet" "subnet1" {
  count                = length(var.subnet_names1)
  name                 = var.subnet_names1[count.index]
  resource_group_name  = data.azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example-2.name
  address_prefixes     = [var.subnet_prefixes1[count.index]]
}
resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "vnet1to2"
  resource_group_name       = data.azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.example-1.name
  remote_virtual_network_id = azurerm_virtual_network.example-2.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "vnet2to1"
  resource_group_name       = data.azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.example-2.name
  remote_virtual_network_id = azurerm_virtual_network.example-1.id
}
//Subnet for APIM
data  "azurerm_subnet" "example" {
  name                 = "APIM_subnet"
  resource_group_name  = data.azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example-2.name
  // subnet_prefixes     = ["10.2.112.0/22"] 
 depends_on = [
 azurerm_subnet.subnet1 ]
}

resource "azurerm_api_management" "example" {
  name                = "example-apimlast5"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  publisher_name      = "My Company"
  publisher_email     = "xxxxxxx@ismiletechnologies.com"
  
  sku_name = "Developer_1"
  virtual_network_type = "Internal" 

  virtual_network_configuration {
    subnet_id = data.azurerm_subnet.example.id
  }
}
// resource "azurerm_api_management_api" "example" {
//   name                = "example-api1"
//   resource_group_name = data.azurerm_resource_group.example.name
//   api_management_name = azurerm_api_management.example.name
//   revision            = "1"
//   display_name        = "Example API"
//   path                = "example"
//   protocols           = ["https"]
// }