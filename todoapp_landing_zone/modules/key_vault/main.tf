data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each                   = var.kvs
  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  tenant_id                  = each.value.tenant_id
  sku_name                   = each.value.sku_name
  soft_delete_retention_days = each.value.soft_delete_retention_days
  purge_protection_enabled   = each.value.purge_protection_enabled
  tags                       = each.value.tags != null ? each.value.tags : {}

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions     = ["Get","List"]
    secret_permissions  = ["Get","List","Set","Delete"]
    storage_permissions = ["Get","List","Set","Delete"]
  }
}
