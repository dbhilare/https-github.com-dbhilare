# Resource Group
module "rg" {   
  source   = "./modules/rg"   
  rg_name  = "database-rg"   
  location = "central india"   
  tags     = {   
    environment = "dev"   
    project     = "sql db instance migration"   
  }   
}

# Virtual Network
module "network" {   
  depends_on = [ module.rg ]
  source              = "./modules/network"   
  namespace           = "database"   
  vnet_name           = "database-vnet"   
  address_space       = ["10.0.0.0/16"]   
  location            = module.rg.location
  rg_name             = module.rg.name
  tags                = module.rg.tags    
}

# Subnet
module "subnet" {
  depends_on = [ module.network ]
  source                = "./modules/subnet"
  subnet_name           = "subnet-mi"
  subnet_address_prefix = ["10.0.1.0/24"]
  rg_name               = module.rg.name
  vnet_name             = module.network.name
}




/*
# NSG
module "nsg" {
  depends_on  = [ module.network ]
  source      = "./modules/nsg_with_rules"
  nsg_name    = "mi-security-group"
  location    = module.rg.location
  rg_name     = module.rg.name
}
*/

# NSG + Rules (single module)
module "nsg_with_rules" {
  depends_on = [module.network, module.subnet ]
  source = "./modules/nsg_with_rules"
  #nsg_name = module.nsg.name
  location = module.rg.location
  rg_name  = module.rg.name
  nsg_name    = "mi-security-group"

  rules = [
    {
      name                        = "allow-management-inbound"
      priority                    = 106
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
    {
      name                        = "allow_misubnet_inbound"
      priority                    = 200
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_ranges     = ["*"]
      source_address_prefix       = "10.0.1.0/24"
      destination_address_prefix  = "*"
    }

  ]
}

# NSG ↔ Subnet Association
module "nsg_association" {
  depends_on = [ module.subnet, module.nsg_with_rules ]
  source     = "./modules/nsg_association"
  subnet_id  = module.subnet.id
  nsg_id     = module.nsg_with_rules.id
}
