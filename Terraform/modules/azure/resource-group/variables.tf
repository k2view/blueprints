variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "create_resource_group" {
  type        = bool
  description = "Whether to create the resource group (set to false to use an existing one)"
  default     = true
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "West Europe"
}

variable "tags" {
  type        = map
  description = "Tags to apply to all resources"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2vDev" }
}