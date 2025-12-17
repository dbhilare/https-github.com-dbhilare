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

# NSG
module "nsg" {
  depends_on  = [ module.network ]
  source      = "./modules/nsg_with_rules"
  nsg_name    = "mi-security-group"
  location    = module.rg.location
  rg_name     = module.rg.name
}

# NSG ↔ Subnet Association
module "nsg_association" {
  depends_on = [ module.subnet, module.nsg ]
  source     = "./modules/nsg_association"
  subnet_id  = module.subnet.id
  nsg_id     = module.nsg.id
}

