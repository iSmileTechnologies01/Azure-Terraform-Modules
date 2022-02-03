locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)
}

# Public IP for Firewall
resource "azurerm_public_ip" "firewall-ip" {
  name                = "pip-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_firewall" "az_firewall" {
  name                = "fw-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  ip_configuration {
    name                 = "az_firewall_ip_configuration"
    subnet_id            = "azurerm_subnet.example.id"
    public_ip_address_id = azurerm_public_ip.firewall-ip.id
  }
}
