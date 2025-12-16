# =====================================================
# variables.tf
# =====================================================
variable "location" {
description = "Azure region"
type = string
default = "Central India"
}

variable "resource_group_name" {
description = "Resource Group name"
type = string
default = "Source-RG1"
}

variable "vm_admin_username" {
description = "VM admin username"
type = string
default = "sqladmin"
}

variable "vm_admin_password" {
description = "VM admin password"
type = string
sensitive = true
default = "Bhag@123"
}

variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
  default     = "SampleDB"
}