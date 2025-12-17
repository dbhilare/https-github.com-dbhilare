variable "rgs" {}
variable "vnets" {}
variable "vms" {}
variable "subnets" {}

resource "azurerm_resource_group" "rg" {
  for_each = var.rgs
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_virtual_network" "myvnet" {
  depends_on          = [azurerm_resource_group.rg]
  for_each            = var.vnets
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
}

resource "azurerm_subnet" "fe_vm_subnet" {
  depends_on           = [azurerm_virtual_network.myvnet]
  for_each             = var.subnets
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
  address_prefixes     = each.value.address_prefixes
}

data "azurerm_subnet" "subnet" {
  depends_on           = [azurerm_subnet.fe_vm_subnet]
  for_each             = var.subnets
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_public_ip" "vm_pip" {
  depends_on          = [azurerm_resource_group.rg]
  for_each            = var.vms
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
}

data "azurerm_public_ip" "pip1" {
  depends_on          = [azurerm_public_ip.vm_pip]
  for_each            = var.vms
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_interface" "nic" {
  depends_on          = [azurerm_subnet.fe_vm_subnet]
  for_each            = var.vms
  name                = each.value.network_interface_card_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name = "internal"
    # subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    subnet_id                     = data.azurerm_subnet.subnet[each.value.subnet_key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.pip1[each.key].id
  }
}

resource "azurerm_virtual_machine" "vm" {
  for_each              = var.vms
  name                  = each.value.name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  vm_size               = each.value.vm_size

  storage_image_reference {
    publisher = each.value.storage_image_reference.publisher
    offer     = each.value.storage_image_reference.offer
    sku       = each.value.storage_image_reference.sku
    version   = each.value.storage_image_reference.version
  }

  storage_os_disk {
    name              = each.value.storage_os_disk.name
    caching           = each.value.storage_os_disk.caching
    create_option     = each.value.storage_os_disk.create_option
    managed_disk_type = each.value.storage_os_disk.managed_disk_type
  }

  os_profile {
    computer_name  = each.value.os_profile.computer_name
    admin_username = each.value.os_profile.admin_username
    admin_password = each.value.os_profile.admin_password
  }

  os_profile_linux_config {
      disable_password_authentication = each.value.os_profile_linux_config.disable_password_authentication
    }

}
