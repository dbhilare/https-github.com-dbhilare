variable "vnets" {
  type = map(object({
    vnet_name           = string
    address_space       = list(string)
    location            = string
    resource_group_name = string
     
    #subnets = optional(list(object({
    subnets = optional(map(object({
      name             = string
      address_prefixes = list(string)
      }
    )))
  }))
}

