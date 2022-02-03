provider "azurerm" {
  features {}
}

resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  location            = var.location
  sku                 = var.sku_name
  name                = var.eventhub_namespace_name
  resource_group_name = var.resource_group_name
}
