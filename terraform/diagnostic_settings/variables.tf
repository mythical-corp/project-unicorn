variable management_group_id {
    type = string
    description = "The root Management Group to be used as policy definition assignment scope."
}

variable "storage_account_id" {
  type = any
  description = "The Resource ID of the central storage account used for storing the diagnostic settings."
  default = {}
}


variable "policy_name" {
  type        = string
  description = "Name to be used for this policy."
  default     = ""

  validation {
    condition     = length(var.policy_name) <= 64
    error_message = "Definition names have a maximum 64 character limit. Ensure this matches the filename within the local policies library."
  }
}

variable "display_name" {
  type        = string
  description = "Display Name to be used for this policy."
  default     = ""

  validation {
    condition     = length(var.display_name) <= 128
    error_message = "Definition display names have a maximum 128 characters limit."
  }
}

variable "policy_description" {
  type        = string
  description = "Policy Definition Description"
  default     = ""

  validation {
    condition     = length(var.policy_description) <= 512
    error_message = "Definition description have a maximum 512 character limit."
  }
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

variable "policy_parameters" {
  type        = string
  description = "Parameters for the policy definition. This field is a JSON Object that allows you to parameterise your policy definition. Omitting this assumes the parametes are located in /policies/var.policy_name.json"
  default     = null
}


variable "policy_rule" {
  type        = string
  description = "The policy rule for the policy definition. This field is a JSON Object representing the rule that contains an if and a then block. Omitting this assumes the rule is located in /policies/var.policy_name.json"
  default     = null
}

variable "policy_metadata" {
  type        = any
  description = "The metadata for the policy definition. This field is a JSON Object representing additional metadata that should be stored with the policy definition. Omitting this assumes the metadata is located in /policies/var.policy_name.json"
  default     = null
}

variable "file_path" {
  type        = any
  description = "The filepath to the custom policy. Omitting this assumes the policy is located in the module library."
  default     = null

}

locals {
  policy_object = jsondecode(coalesce(try(
    file(var.file_path),
    file("${path.cwd}/${var.policy_name}.json"),
    file("${path.root}/${var.policy_name}.json"),
    file("${path.root}/../${var.policy_name}.json"),
    file("${path.root}/../../${var.policy_name}.json"),
  )))

  title    = title(replace(local.policy_name, "/-|_|\\s/", " "))
  category = "Monitoring"
  version  = "1.0.0"

  policy_name  = coalesce(var.policy_name, try((local.policy_object).name, null))
  display_name = coalesce(var.display_name, try((local.policy_object).properties.displayName, local.title))
  description  = coalesce(var.policy_description, try((local.policy_object).properties.description, local.title))
  metadata     = coalesce(var.policy_metadata, try((local.policy_object).properties.metadata))
  parameters   = coalesce(var.policy_parameters, try((local.policy_object).properties.parameters, null))
  policy_rule  = coalesce(var.policy_rule, try((local.policy_object).properties.policyRule, null))


}
