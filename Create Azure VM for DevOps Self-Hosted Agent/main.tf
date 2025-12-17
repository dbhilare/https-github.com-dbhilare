# -----------------------------------------------------
# Resource Group
# -----------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# -----------------------------------------------------
# Virtual Network + Subnet
# -----------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "${var.vm_name}-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

# -----------------------------------------------------
# Public IP
# -----------------------------------------------------
resource "azurerm_public_ip" "pip" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# -----------------------------------------------------
# Network Security Group
# -----------------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-RDP-6516"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6516"
    source_address_prefix      = "*" # Replace with your real office public IP
    destination_address_prefix = "*"
  }
}

# -----------------------------------------------------
# NIC
# -----------------------------------------------------
resource "azurerm_network_interface" "nic" {
  depends_on          = [azurerm_virtual_network.vnet]
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  depends_on                = [azurerm_network_security_group.nsg]
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# -----------------------------------------------------
# Windows VM
# -----------------------------------------------------
resource "azurerm_windows_virtual_machine" "vm" {
  depends_on          = [azurerm_subnet.subnet]
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}

# -----------------------------------------------------
# Custom Script to Install Azure DevOps Agent
# -----------------------------------------------------
resource "azurerm_virtual_machine_extension" "install_devops_agent" {
  name                 = "install-devops-agent"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = <<PSETTINGS
{
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"Set-Content -Path 'C:\\install-agent.ps1' -Value ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(file("install-agent.ps1"))}'))); powershell -ExecutionPolicy Unrestricted -File C:\\install-agent.ps1 -OrgUrl '${var.devops_org_url}' -PAT '${var.personal_access_token}'\""
}
PSETTINGS
}
