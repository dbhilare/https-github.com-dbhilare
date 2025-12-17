output "name" {
  value = azurerm_network_security_group.example.name
}

output "location" {
  value = azurerm_network_security_group.example.location
}

output "resource_group_name" {
  value = azurerm_network_security_group.example.resource_group_name
}

output "id" {
  value = azurerm_network_security_group.example.id
}

/*
output "id" {
  description = "The ID of the NSG association."
  value       = azurerm_subnet_network_security_group.example.id
} 
*/

/*
output "security_rule_name" {
  value = azurerm_network_security_rule.allow_management_inbound.name
}

output "priority" {
  value = azurerm_network_security_rule.allow_management_inbound.priority
}

output "direction" {
  value = azurerm_network_security_rule.allow_management_inbound.direction
}
output "access" {
  value = azurerm_network_security_rule.allow_management_inbound.access
}
output "protocol" {
  value = azurerm_network_security_rule.allow_management_inbound.protocol
}
output "source_port_range" {
  value = azurerm_network_security_rule.allow_management_inbound.source_port_range
}
output "destination_port_ranges" {
  value = azurerm_network_security_rule.allow_management_inbound.destination_port_ranges
}
output "source_address_prefix" {
  value = azurerm_network_security_rule.allow_management_inbound.source_address_prefix
}
output "destination_address_prefix" {
  value = azurerm_network_security_rule.allow_management_inbound.destination_address_prefix
}
*/