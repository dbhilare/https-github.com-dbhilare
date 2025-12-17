resource "azurerm_network_security_group" "example" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name
}



