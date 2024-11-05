variable "resource_group_name" {
  type        = string
  description = "Resource Group name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "acr_name" {
  type        = string
  description = "The name of ACR (only lowercase letters)"
}

variable "acr_admin_enabled" {
  type        = bool
  description = "Enable ACR admin user to push images."
  default     = true
}

variable "tags" {
  type        = map
  description = "Tags values"
  default     = {}
  #tags={ Env = "Dev", Owner = "k2view", Project = "k2vDev" }
}

variable "principal_id" {
  type        = string
  description = "The kubelet identity ID"
}
