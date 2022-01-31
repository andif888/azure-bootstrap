resource "azurerm_resource_group" "storage" {
  name     = var.azure_bootstrap_resource_group_name
  location = var.azure_location
  tags     = var.azure_tags
}

resource "azurerm_storage_account" "storage" {
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  name                     = var.azure_bootstrap_storage_account_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  min_tls_version          = "TLS1_2"
  tags                     = var.azure_tags

  depends_on = [azurerm_resource_group.storage]
}

resource "azurerm_storage_container" "storage" {
  storage_account_name  = azurerm_storage_account.storage.name
  name                  = var.azure_bootstrap_storage_account_container_name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.storage]
}

output "storage_account_primary_access_key" {
  value = azurerm_storage_account.storage.primary_access_key
  sensitive = true
}
