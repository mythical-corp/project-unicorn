output "storage_account_id" {
    value = azurerm_storage_account.flowlogs.id
}

output "storage_account_name" {
    value = azurerm_storage_account.flowlogs.name
}

output "storage_account_rg" {
    value = azurerm_resource_group.flowlogs.name
}

output "storage_account_container" {
    value = azurerm_storage_container.tfstate.name
}