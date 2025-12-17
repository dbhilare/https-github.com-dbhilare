module "resource_group" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "azurerm_key_vault" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_keyvault"
  kvs        = var.kvs
}

module "azurerm_virtual_network" {
  depends_on = [ module.resource_group ]
  source = "../../modules/azurerm_networking"
  vnets  = var.vnets
}

module "azurerm_nic" {
  depends_on = [ module.azurerm_virtual_network ]
  source = "../../modules/azurerm_nic"
  nics = var.nics
}