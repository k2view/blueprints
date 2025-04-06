variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "create_resource_group" {
  type        = bool
  description = "Create RG name in Azure"
  default     = true
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "tags" {
  type        = map
  description = "Tags value"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2vDev" }
}