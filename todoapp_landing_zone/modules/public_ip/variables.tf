variable "public_ips" {
  type = map(object({
    name                    = string
    resource_group_name     = string
    location                = string
    allocation_method       = string
    sku                     = optional(string)
    sku_tier                = optional(string)
    zones                   = optional(list(string))
    ip_version              = optional(string)
    domain_name_label       = optional(string)
    domain_name_label_scope = optional(string)
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    edge_zone               = optional(string)
    idle_timeout_in_minutes = optional(number)
    ip_tags                 = optional(map(string))
    public_ip_prefix_id     = optional(string)
    reverse_fqdn            = optional(string)
    tags                    = optional(map(string))
  }))
  default = {}
}


/*
variable "public_ips" {
  type = map(object({
    name              = string
    resource_group    = string
    location          = string
    allocation_method = string
    # sku                     = Optional(string, "Standard")
    sku_tier                = Optional(string, "Regional")
    zones                   = Optional(list(string), [])
    ip_version              = Optional(string, "IPV4")
    domain_name_label       = Optional(string)
    domain_name_label_scope = Optional(string)
    ddos_protection_mode    = Optional(string, "VirtualNetworkInherited")
    ddos_protection_plan_id = Optional(string)
    edge_zone               = Optional(string)
    idle_timeout_in_minutes = Optional(number, 4)
    ip_tags                 = Optional(map(string), {})
    public_ip_prefix_id     = Optional(string)
    reverse_fqdn            = Optional(string)
    tags                    = Optional(map(string), {})
  }))
}
*/
