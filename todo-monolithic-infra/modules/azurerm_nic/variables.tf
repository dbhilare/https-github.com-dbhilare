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
