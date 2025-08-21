variable "management_group_id" {
  type        = string
  description = "The root Management Group to be used as policy definition assignment scope."
}

variable "storage_account_id" {
  type        = any
  description = "The Resource ID of the central storage account used for storing the diagnostic settings."
  default     = {}
}

variable "policy_mode" {
  type        = string
  description = "The policy mode that allows you to specify which resource types will be evaluated, defaults to All. Possible values are All and Indexed."
  default     = "All"

  validation {
    condition     = var.policy_mode == "All" || var.policy_mode == "Indexed"
    error_message = "Policy mode possible values are: All or Indexed."
  }
}

variable "policy_category" {
  type        = string
  description = "The category for the policy."
  default     = "Monitoring"
}


locals {
  policy_json = jsondecode(file("vnet_policy.json"))

  parameters   = try(local.policy_json.properties.parameters, {})
  policy_rule  = try(local.policy_json.properties.policyRule, {})
  metadata     = try(local.policy_json.metadata, {})
  policy_name  = try(local.policy_json.name, "default-policy-name")
  display_name = try(local.policy_json.properties.displayName, "Default Display Name")
  description  = try(local.policy_json.properties.description, "No description provided")
  category     = try(local.policy_json.properties.metadata.category, "Monitoring")
}
