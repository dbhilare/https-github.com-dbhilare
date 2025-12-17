variable "stg_account" {
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    account_tier                 = string
    account_replication_type     = string
    tags                         = optional(map(string))
  }))
}