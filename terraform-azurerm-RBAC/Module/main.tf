locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)
}

data "azurerm_subscription" "current" {
}

data "azuread_group" "sub_group" {
  for_each     = toset(var.aad_group_names_sub)
  display_name = each.key
}

resource "azurerm_role_assignment" "az_role_assign_sub" {
  for_each = toset(var.aad_group_names_sub)

  scope                = data.azurerm_subscription.current.id
  role_definition_name = var.role_mapping_sub["${each.key}"]
  principal_id         = data.azuread_group.sub_group["${each.key}"].id

}
data "azurerm_management_group" "this" {
  count = var.mg_group_names != "" ? 1 : 0
  name  = var.mg_group_names
}

data "azuread_group" "mg_group" {
  for_each     = toset(var.aad_group_names_mg)
  display_name = each.key
}

resource "azurerm_role_assignment" "az_role_assign_mg" {
  for_each = toset(var.aad_group_names_mg)

  scope                = data.azurerm_management_group.this[0].id
  role_definition_name = var.role_mapping_mg["${each.key}"]
  principal_id         = data.azuread_group.mg_group["${each.key}"].id

}

