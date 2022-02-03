provider "azurerm" {
  features {}
}
module "rbac" {
  source              = "./Module"
  resource_group_name = "resourcegroupname"
}