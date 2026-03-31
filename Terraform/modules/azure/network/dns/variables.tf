variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "create_resource_group" {
  type        = bool
  description = "Whether to create the resource group (set to false to use an existing one)"
  default     = false
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "West Europe"
}

variable "domain" {
  type        = string
  description = "Domain name for the public DNS zone"
}

variable "record_ip" {
  type        = string
  description = "IP address for the DNS A records"
  default     = "1.1.1.1"
}

variable "dns_record_name" {
  type        = string
  description = "Name of the DNS A record (use * for wildcard)"
  default     = "*"
}

variable "tags" {
  type        = map
  description = "Tags to apply to all resources"
  #tags={ Env = "Dev", Owner = "owner_name", Project = "k2vDev" }
}
