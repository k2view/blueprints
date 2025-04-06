variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
  default     = ""
}

variable "use_existing_acr" {
  description = "If true, use an existing ACR; if false, create a new one."
  type        = bool
  default     = false
}

variable "existing_acr_name" {
  description = "The name of the existing ACR to use when 'use_existing_acr' is true."
  type        = string
  default     = null
}

variable "existing_acr_resource_group" {
  description = "The resource group of the existing ACR."
  type        = string
  default     = null
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "acr_name" {
  type        = string
  description = "The name of ACR (only lowercase letters)"
  default     = ""
}

variable "acr_admin_enabled" {
  type        = bool
  description = "Enable ACR admin user to push images."
  default     = true
}

variable "tags" {
  type        = map
  description = "Tags value"
  default     = {}
  #tags={ Env = “Dev”, Owner = “k2view”, Project = "k2vDev" }
}

# variable "principal_id" {
#   type        = string
#   description = "The kubelet identity id"
# }
