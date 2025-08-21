resource "azurerm_resource_group" "flowlogs" {
  name     = "rg-flowlogs-${var.tenant_name}"
  location = var.location
}

resource "azurerm_storage_account" "flowlogs" {
    name = "st${var.tenant_name}flowlogs"
    resource_group_name = azurerm_resource_group.flowlogs.name
    location = azurerm_resource_group.flowlogs.location
    account_tier = "Standard"
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

resource "azurerm_storage_container" "tfstate" {
  name = "tfstates"
  storage_account_id = azurerm_resource_group.flowlogs.id
  container_access_type = "private"
}
