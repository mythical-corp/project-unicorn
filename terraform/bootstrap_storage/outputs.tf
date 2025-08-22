output "storage_account_rg" {
    value = azurerm_resource_group.central_storage.name
}

output "storage_account_name" {
    value = azurerm_storage_account.central_storage.name
}

output "storage_account_container" {
    value = azurerm_storage_container.central_storage.name
}