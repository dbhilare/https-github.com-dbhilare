resource "azurerm_resource_group" "example" {
  for_each   = var.rg_name
  name       = each.value.name
  location   = each.value.location
  managed_by = each.value.managedby
  tags       = each.value.tags
}
