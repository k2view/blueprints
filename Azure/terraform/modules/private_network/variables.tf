variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "prefix_name" {
  type        = string
  description = "Prefix for network names"
}

variable "virtual_network_address_space" {
  type        = string
  description = "Virtual network address space CIDR"
  default     = "10.0.0.0/8"
}

variable "subnet_address_prefixes" {
  type        = string
  description = "Virtual network subnet address prefixes CIDR"
  default     = "10.240.0.0/16"
}

variable "tags" {
  type        = map
  description = "Tags value"
  default     = {}
  #tags={ Env = “Dev”, Owner = “k2view”, Project = "k2vDev" }
}
