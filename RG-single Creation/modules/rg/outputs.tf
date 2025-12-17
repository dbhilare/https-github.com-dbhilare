output "name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.example.name
}

output "location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.example.location
}

output "tags" {
  description = "The tags assigned to the resource group"
  value       = azurerm_resource_group.example.tags
}

