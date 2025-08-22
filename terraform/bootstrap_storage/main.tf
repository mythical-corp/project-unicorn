# Creates resource group in default subscription
resource "azurerm_resource_group" "central_storage" {
  name     = "rg-central-${var.tenant_name}"
  location = var.location
}

# Creates central storage account in default subscription
resource "azurerm_storage_account" "central_storage" {
  name                     = "stcentral${replace(lower(var.tenant_name), "-", "")}"
  resource_group_name      = azurerm_resource_group.central_storage.name
  location                 = azurerm_resource_group.central_storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Creates container for terraform state in central storage account
resource "azurerm_storage_container" "central_storage" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.central_storage.name
  container_access_type = "private"
}
