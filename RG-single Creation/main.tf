module "rg" {   
  source   = "./modules/rg"   
  rg_name  = "database-rg"   
  location = "central india"   
  tags     = {   
    environment = "dev"   
    project     = "sql db instance migration"   
  }   
}