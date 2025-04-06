variable "prefix_name" {
  type        = string
  description = "Prefix for network names"
}

variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"
}

variable "subnet_address_prefixes" {
  type        = string
  description = "Virtual network subnet address prefixes CIDR"
  default     = "10.240.0.0/16"
}

variable "nat_gateway_id" {
  type        = string
  description = "NAT Gateway ID"
  default     = ""
}

variable "create_route_table" {
  type        = bool
  description = "Create route table as a gateway."
  default     = false
}

variable "route_table_id" {
  type        = string
  description = "Route Table ID"
  default     = ""
}