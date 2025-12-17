resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}

