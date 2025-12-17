resource "azurerm_network_security_group" "example" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name
}


resource "azurerm_network_security_rule" "rules" {
  for_each = { for rule in var.rules : rule.name => rule }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range 
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.example.name

  destination_port_ranges     = lookup(each.value,"destination_port_ranges",null)
  destination_port_range      = lookup(each.value,"destination_port_range",null)
}