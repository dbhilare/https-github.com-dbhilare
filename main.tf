# -----------------------------
# Resource Group
# -----------------------------

resource "azurerm_resource_group" "source_rg" {
name = var.resource_group_name
location = var.location
}

# -----------------------------
# Networking
# -----------------------------
resource "azurerm_virtual_network" "vnet" {
name = "source-vnet"
address_space = ["10.10.0.0/16"]
location = azurerm_resource_group.source_rg.location
resource_group_name = azurerm_resource_group.source_rg.name
}

resource "azurerm_subnet" "subnet" {
name = "default"
resource_group_name = azurerm_resource_group.source_rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes = ["10.10.1.0/24"]
}

resource "azurerm_public_ip" "vm_pip" {
name = "sql-vm-public-ip"
location = azurerm_resource_group.source_rg.location
resource_group_name = azurerm_resource_group.source_rg.name
allocation_method = "Static"
sku = "Standard"
}

resource "azurerm_network_interface" "nic" {
name = "sql-source-nic"
location = azurerm_resource_group.source_rg.location
resource_group_name = azurerm_resource_group.source_rg.name


ip_configuration {
name = "internal"
subnet_id = azurerm_subnet.subnet.id
private_ip_address_allocation = "Dynamic"
public_ip_address_id = azurerm_public_ip.vm_pip.id
}
}

resource "azurerm_network_security_group" "nsg" {
  name                = "sql-vm-nsg"
  location            = azurerm_resource_group.source_rg.location
  resource_group_name = azurerm_resource_group.source_rg.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # WinRM HTTP
  security_rule {
    name                       = "Allow-WinRM-HTTP"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # WinRM HTTPS
  security_rule {
    name                       = "Allow-WinRM-HTTPS"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # RPC
  security_rule {
    name                       = "Allow-RPC"
    priority                   = 1030
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "135"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # SMB
  security_rule {
    name                       = "Allow-SMB"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# -----------------------------
# Windows SQL Server VM
# -----------------------------
resource "azurerm_windows_virtual_machine" "sql_vm" {
name = "SQL-Source-VM"
resource_group_name = azurerm_resource_group.source_rg.name
location = azurerm_resource_group.source_rg.location
size = "Standard_D2s_v3"
#size = "Standard_D4s_v5"
admin_username = var.vm_admin_username
admin_password = var.vm_admin_password


network_interface_ids = [azurerm_network_interface.nic.id]


os_disk {
name = "sqlosdisk"
caching = "ReadWrite"
storage_account_type = "StandardSSD_LRS"
}


source_image_reference {
publisher = "MicrosoftSQLServer"
offer = "sql2019-ws2019"
sku = "standard-gen2"
version = "latest"
}
}


# -----------------------------
# SQL IaaS Extension
# -----------------------------
resource "azurerm_mssql_virtual_machine" "sql_extension" {
virtual_machine_id = azurerm_windows_virtual_machine.sql_vm.id
sql_license_type = "PAYG"
}

/*
# -----------------------------
# Create SQL Database inside SQL VM (Practice)
# -----------------------------
# This uses sqlcmd via a local-exec provisioner.
# SQL Server must be reachable (RDP enabled, firewall open).


resource "null_resource" "create_sql_database" {
  depends_on = [azurerm_windows_virtual_machine.sql_vm]

  provisioner "local-exec" {
    command = "sqlcmd -S localhost -U ${var.vm_admin_username} -P ${var.vm_admin_password} -Q \"IF DB_ID('PracticeDB') IS NULL CREATE DATABASE PracticeDB;\""
  }
}
*/