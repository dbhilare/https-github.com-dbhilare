variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
}

variable "location" {
  description = "The location of the Network Security Group"
  type        = string
}   

variable "rg_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "rules" {
  description = "The list of Network Security Rules"
  type        = list(object({
    name                        = string
    priority                    = number
    direction                   = string
    access                      = string
    protocol                    = string
    source_port_range           = string
    destination_port_ranges     = optional(list(string))
    destination_port_range     = optional(string)
    source_address_prefix       = string
    destination_address_prefix  = string
  }))
  default = []
}

