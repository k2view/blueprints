variable "prefix_name" {
  type        = string
  description = "Prefix for network names"
}

variable "virtual_network_address_space" {
  type        = string
  description = "Virtual network address space CIDR"
  default     = "10.0.0.0/8"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "create_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT gateway for outbound traffic"
  default     = true
}

variable "create_route_table" {
  type        = bool
  description = "Whether to create a route table for user-defined routing"
  default     = false
}

variable "route_table_address_prefix" {
  type        = string
  description = "Destination CIDR for the outbound route (e.g. 0.0.0.0/0)"
  default     = "0.0.0.0/0"
}

variable "route_table_next_hop_ip" {
  type        = string
  description = "Next hop IP address for user-defined routing (required when create_route_table is true)"
  default     = ""
}

variable "tags" {
  type        = map
  description = "Tags to apply to all resources"
  default     = {}
}