# =====================================================
# outputs.tf
# =====================================================
output "resource_group_name" {
value = azurerm_resource_group.source_rg.name
}


output "sql_vm_name" {
value = azurerm_windows_virtual_machine.sql_vm.name
}