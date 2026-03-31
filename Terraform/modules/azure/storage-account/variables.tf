variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
  default     = ""
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "West Europe"
}

variable "account_name" {
  type        = string
  description = "Storage account name"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "AKS cluster name"
  default     = ""
}

# Account Configuration
variable "account_tier" {
  type        = string
  description = "Storage account performance tier (Standard or Premium)"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Storage account replication type (e.g. LRS, GRS, ZRS)"
  default     = "LRS"
}

variable "account_kind" {
  type        = string
  description = "Storage account kind (e.g. StorageV2, BlobStorage)"
  default     = "StorageV2"
}
