terraform {
  backend "azure" {}
}
provider "azurerm" {
  features {}
}

module "Module" {
  source = "./Module"
   vnet_peering_names=["vnet_peer_1","vnet_peer_2"]
  resource_group_name = "ResourceGroupName"
}