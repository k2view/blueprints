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
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "create_nat_gateway" {
  type        = bool
  description = "Create NAT gateway."
  default     = true
}

variable "create_route_table" {
  type        = bool
  description = "Create route table as a gateway."
  default     = false
}

variable "route_table_address_prefix" {
  type        = string
  description = "Route table address prefix."
  default     = "0.0.0.0/0"
}

variable "route_table_next_hop_ip" {
  type        = string
  description = "IP address of the next hop in the routing table."
  default     = ""
}

variable "tags" {
  type        = map
  description = "Tags value"
  default     = {}
}