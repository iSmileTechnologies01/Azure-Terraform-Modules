#Azure Generic vNet Module
provider "azurerm" {
  features {}
}
terraform {
  backend "azure" {}
}
data azurerm_resource_group "vnet" {
  name = var.resource_group_name
}
//vnet1 config
resource azurerm_virtual_network "vnet" {
  name                = var.vnet_name[0]
  resource_group_name = data.azurerm_resource_group.vnet.name
  location            = data.azurerm_resource_group.vnet.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}
//vnet 2 configuration
resource azurerm_virtual_network "vnet2" {
  name                = var.vnet_name[1]
  resource_group_name = data.azurerm_resource_group.vnet.name
  location            = data.azurerm_resource_group.vnet.location
  address_space       = var.address_space1
  dns_servers         = var.dns_servers
  tags                = var.tags
}
//## Gateway Subnet ## //
resource "azurerm_subnet" "Gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/19"]
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
  service_endpoints    = lookup(var.subnet_service_endpoints, var.subnet_names[count.index], null)
}
//vnet 2 address 
resource "azurerm_subnet" "subnet1" {
  count                = length(var.subnet_names1)
  name                 = var.subnet_names1[count.index]
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = [var.subnet_prefixes1[count.index]]
  service_endpoints    = lookup(var.subnet_service_endpoints, var.subnet_names1[count.index], null)
}

locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }
}

resource "azurerm_subnet_network_security_group_association" "vnet" {
  for_each                  = var.nsg_ids
  subnet_id                 = local.azurerm_subnets[each.key]
  network_security_group_id = each.value
}

resource "azurerm_subnet_route_table_association" "vnet" {
  for_each       = var.route_tables_ids
  route_table_id = each.value
  subnet_id      = local.azurerm_subnets[each.key]
}


