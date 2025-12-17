variable "rg_name" {
  type = map(object({
    name      = string
    location  = string
    managedby = optional(string)
    tags      = optional(map(string))
  }))
}
