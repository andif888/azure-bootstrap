variable "azure_location" {
  type    = string
  default = "Germany West Central"
}

variable "azure_tags" {
  type        = map(string)
  description = "(map[string]string) - Name/value pair tags to apply to every resource deployed i.e. Resource Group, VM, NIC, VNET, Public IP, KeyVault, etc. The user can define up to 15 tags. Tag names cannot exceed 512 characters, and tag values cannot exceed 256 characters."

  default = {
    source = "bootstrap"
  }
}

variable "azure_bootstrap_resource_group_name" {
  type    = string
  default = ""
}

variable "azure_bootstrap_storage_account_name" {
  type    = string
  default = ""
}

variable "azure_bootstrap_storage_account_container_name" {
  type    = string
  default = ""
}
