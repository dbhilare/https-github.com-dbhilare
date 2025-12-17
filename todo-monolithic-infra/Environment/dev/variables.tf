variable "rgs" {
  description = "A map of resource group names and their locations"
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}

variable "kvs" {
  description = "Key vaults configuration for this environment"
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    tenant_id                  = string
    sku_name                   = string
    soft_delete_retention_days = number
    purge_protection_enabled   = bool
    tags                       = optional(map(string))
    key_permissions            = list(string)
    secret_permissions         = list(string)
    storage_permissions        = list(string)
  }))
}

variable "vnets" {
  type = map(object({
    vnet_name           = string
    address_space       = list(string)
    location            = string
    resource_group_name = string
     
    subnets = optional(map(object({
      name             = string
      address_prefixes = list(string)
      }
    )))
  }))
}

variable "nsgs" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}

variable "nics" {
  type = map(object({
    name     = string
    location = string
    resource_group_name = string
    subnet_name = string
    virtual_network_name = string
    nsg_name = string
    # subnet_id = string
    # public_ip_id = optional(string)
  }))
}

/*
# Declare kvs variable for this environment to satisfy module input.
# Adjust the type and default to match what ../../modules/azurerm_keyvault expects.
variable "kvs" {
  description = "Key vaults configuration for this environment (map of key vault definitions)"
  type        = map(any)
  default     = {}
}

variable "kvs" {
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    tenant_id                  = string
    sku_name                   = string
    soft_delete_retention_days = number
    purge_protection_enabled   = bool
    tags                       = optional(map(string))
    key_permissions            = list(string)
    secret_permissions         = list(string)
    storage_permissions        = list(string)
  }))
}
*/
