data "azurerm_management_group" "root-mg" {
  name = var.management_group_id
}

resource "azurerm_policy_definition" "def" {
  name         = local.policy_name
  display_name = local.display_name
  description  = local.description
  policy_type  = "Custom"
  mode         = var.policy_mode

  management_group_id = var.management_group_id

  metadata    = jsonencode(local.metadata)
  parameters  = length(local.parameters) > 0 ? jsonencode(local.parameters) : null
  policy_rule = jsonencode(local.policy_rule)

  lifecycle {
    create_before_destroy = false
  }

  timeouts {
    read = "10m"
  }
}

resource "azurerm_resource_policy_assignment" "def_assign" {
  name                 = "vnet-policy"
  resource_id          = data.azurerm_management_group.root-mg.id
  policy_definition_id = azurerm_policy_definition.def.id

  parameters = jsonencode({
    storageAccountId = {
      value = var.storage_account_id 
    }
  })
}
