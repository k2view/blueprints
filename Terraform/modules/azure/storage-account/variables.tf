variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
  default     = ""
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "account_name" {
  type        = string
  description = "Storage Account Name"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
  default     = ""
}

// Accoutn Configuration
variable "account_tier" {
  type        = string
  description = "Storage Account Tier"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Storage Account Replication Type"
  default     = "LRS"
}

variable "account_kind" {
  type        = string
  description = "Storage Account Kind"
  default     = "StorageV2"
}