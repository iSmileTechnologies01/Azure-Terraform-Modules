locals {
  blobs = [
    for b in var.blobs : merge({
      type         = "Block"
      size         = 0
      content_type = "application/octet-stream"
      source_file  = null
      source_uri   = null
      attempts     = 1
      metadata     = {}
    }, b)
  ]

  account_tier             = (var.kind == "FileStorage" ? "Premium" : split("_", var.sku)[0])
  account_replication_type = (local.account_tier == "Premium" ? "LRS" : split("_", var.sku)[1])
}

# resource "azurerm_resource_group" "rg3" {
#    name     = var.resource_group_name
#    location = var.location
# }

################################
# Storage Account
################################
resource "azurerm_storage_account" "main" {
  name                      = var.name
  resource_group_name       = "resourcegroupname"
  location                  = var.location
  account_kind              = var.kind
  account_tier              = local.account_tier
  account_replication_type  = local.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = var.https_only
  tags                      = var.tags

  identity {
    type = var.assign_identity ? "SystemAssigned" : null
  }
  network_rules {
    default_action             = var.network_rules.default_action
    bypass                     = var.network_rules.bypass
    ip_rules                   = var.network_rules.ip_rules
    virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids
  }

}

resource "azurerm_storage_container" "main" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = var.containers[count.index].access_type
}

resource "azurerm_storage_blob" "main" {
  count                  = length(local.blobs)
  name                   = local.blobs[count.index].name
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = local.blobs[count.index].container_name
  type                   = local.blobs[count.index].type
  size                   = local.blobs[count.index].size
  content_type           = local.blobs[count.index].content_type
  source                 = local.blobs[count.index].source_file != null ? "${path.root}/${local.blobs[count.index].source_file}" : null
  source_uri             = local.blobs[count.index].source_uri
  metadata               = local.blobs[count.index].metadata
  depends_on             = [azurerm_storage_container.main]
}