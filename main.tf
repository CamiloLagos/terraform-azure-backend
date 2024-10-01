provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfstate" {
  name     = upper("rg-${var.correlativo}-tf-${var.proyecto}-${var.workspace}")
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "tfstate" {
  name                     = lower("tf${var.proyecto}${var.ambiente}")
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_account_customer_managed_key" "encryption" {
  storage_account_id = azurerm_storage_account.sql_account.id
  key_vault_id       = var.key_vault_id
  key_name           = var.key_name
}

resource "azurerm_storage_container" "tfstate" {
  name                  = lower("tf${var.proyecto}${var.ambiente}")
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
