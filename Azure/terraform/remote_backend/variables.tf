variable "create_resource_group" {
  type        = bool
  description = "Create a resource group name in Azure"
  default     = true
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  type        = string
  description = "The location of resources in Azure"
  default     = "West Europe"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account (only lowercase letters)"
  default     = ""
}

variable "container_name" {
  type        = string
  description = "The name of the container within the backend storage account where the Terraform state file will be stored."
  default     = "tfstate"
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
  description = "Tags values"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2vDev" }
}