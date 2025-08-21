variable tenant_name {
    type = string
    description = "The name of the tenant referenced from GitHub environment variable."
}

variable location {
    type = string
    description = "Default location for bootstrap storage account. Value from GitHub environment variable. Omitting defaults to 'northeurope'"
    default = "northeurope"
    
    validation {
      condition = var.location == "northeurope"
      error_message = "Location is restricted by admin."
    }
}