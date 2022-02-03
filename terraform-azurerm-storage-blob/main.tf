provider "azurerm" {
  features {}
}
module "storage-blob" {
  source              = "./Module"
  name                = "projectname"
  resource_group_name = "resourcegroupname"
}