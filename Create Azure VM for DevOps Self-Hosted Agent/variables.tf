variable "resource_group_name" {
  default = "devops-agent-rg"
}

variable "location" {
  default = "centralindia"
}

variable "vm_name" {
  default = "devops-win-agnt"
}

variable "admin_username" {
  default = "azureadmin"
}

variable "admin_password" {
  description = "Password for Windows VM"
  sensitive   = true
}

variable "agent_pool_name" {
  default = "mazagentpool"
}

variable "azure_devops_org_url" {
  default = "https://dev.azure.com/dsankpal"
}

variable "pat_token" {
  description = "Azure DevOps PAT token"
  sensitive   = true
}

variable "devops_org_url" {
  description = "Azure DevOps organization URL"
  type        = string
}

variable "personal_access_token" {
  description = "Azure DevOps PAT token"
  type        = string
  sensitive   = true
}