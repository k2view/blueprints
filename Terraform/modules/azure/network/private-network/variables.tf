variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "create_network" {
  type        = bool
  description = "Create Vnet for the AKS cluster"
  default     = true
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

variable "public_ip" {
  type        = bool
  description = "Create public IP for the NAT or no."
  default     = true
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
  #tags={ Env = “Dev”, Owner = “k2view”, Project = "k2vDev" }
}

variable "subnet_id" {
  type        = string
  description = "Virtual network subnet ID for existing Vnet"
  default     = ""
}
