# Azure datacenter in which your VM will build.
azure_location                  = "Germany West Central"

# Azure tags
azure_tags = {
  "environment" = "plyg02",
  "source" = "bootstrap"
}

# Name of the resource-group hosting a storage account for terraform state files
azure_bootstrap_resource_group_name = "rg-plyg02-bootstrap"

# Name of the storage account to save terraform state files
azure_bootstrap_storage_account_name = "stplyg02bs"

# Name of the blob container to save terraform state files
azure_bootstrap_storage_account_container_name = "terraformstates"
