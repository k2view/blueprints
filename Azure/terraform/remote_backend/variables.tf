variable "create_resource_group" {
  type        = bool
  description = "Create RG name in Azure"
  default     = true
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "storage_account_name" {
  type        = string
  description = "The name of storage account (only lowercase letters)"
}

variable "account_tier" {
  description = "The performance tier of the storage account."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account."
  type        = string
  default     = "LRS"
}

variable "tags" {
  type        = map(string)
  description = "Tags value"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2vDev" }
}