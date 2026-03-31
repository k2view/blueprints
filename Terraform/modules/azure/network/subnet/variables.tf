variable "prefix_name" {
  type        = string
  description = "Prefix for network names"
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network to create the subnet in"
}

variable "subnet_address_prefixes" {
  type        = string
  description = "Subnet address space in CIDR notation"
  default     = "10.240.0.0/16"
}

variable "nat_gateway_id" {
  type        = string
  description = "Resource ID of the NAT gateway to associate with the subnet"
  default     = ""
}

variable "create_route_table" {
  type        = bool
  description = "Whether to associate a route table with the subnet"
  default     = false
}

variable "route_table_id" {
  type        = string
  description = "Resource ID of the route table to associate with the subnet"
  default     = ""
}
