provider "azurerm" {
  features {}
}
module "firewall" {
  source              = "./Module"
#  name                = "projectname"
  resource_group_name = "resourcegroupname"
  virtual_network_name = "Hub_AM_Vnet"
#  fw_subnet = "FW-untrust_subnet4"
#  fw_mgmt_subnet = "FW-MGMT_subnet2"
  app_name = "Trial"
  environment = "Random"
  location = "eastus"
  tags = {}
}