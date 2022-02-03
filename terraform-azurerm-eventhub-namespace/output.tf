output "eventhub_namespace_id" {
  description = "ID of the namespace"
  value = azurerm_eventhub_namespace.eventhub_namespace.id
}

output "name" {
  description = "Name of the namespace"
  value = azurerm_eventhub_namespace.eventhub_namespace.name
}

output "default_primary_connection_string" {
  sensitive   = true
  description = "The primary connection string for the authorization rule RootManageSharedAccessKey"
  value       = azurerm_eventhub_namespace.eventhub_namespace.default_primary_connection_string
}
