// VNETS CANNOT have the same address space
terraform {
  backend "azurerm" {}
}
provider "azurerm"{
  features{}
}
data "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  }

resource "azurerm_virtual_network" "example-1" {
  name                = "VNET-1"
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
  name                = "VNET-2"
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
