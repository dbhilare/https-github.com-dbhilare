resource "azurerm_network_interface" "nic" {
  for_each            = var.nics
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  ip_configuration {
    name                          = "ipconfig1"
    # subnet_id                     = each.value.subnet_id
    subnet_id                     = "/subscriptions/f001856d-d6ec-4585-a826-fa384ad15040/resourcegroups/${each.value.resource_group_name}/providers/Microsoft.Networks/${each.value.virtual_network_name}/subnets/${each.value.subnet_name}"
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = try(each.value.public_ip_id, null)
  }
}
