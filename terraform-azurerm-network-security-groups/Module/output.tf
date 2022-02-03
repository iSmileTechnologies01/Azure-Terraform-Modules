output "network_security_group_id" {
  value = azurerm_network_security_group.nsg.id
}

output "network_security_group_name" {
  value = azurerm_network_security_group.nsg.name
}

output "diagnostics_setting_id" {
  value = azurerm_monitor_diagnostic_setting.nsg_diag.*.id
}