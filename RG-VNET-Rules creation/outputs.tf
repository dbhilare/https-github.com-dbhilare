output "resource_group" {
  description = "The name of the resource group"
  value       = module.rg.name
} 

output "virtual_network" {
  description = "The name of the virtual network"
  value       = module.network.name
}

output "subnet" {
  description = "The name of the subnet"
  value       = module.subnet.name
}

/*
output "nsg" {
  description = "The name of the network security group"
  value       = module.nsg.name
}
*/

