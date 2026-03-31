variable "vpc_name" {
    type = string
    description = "VPC name"
    default = ""
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = ""
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for subnets"
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = []
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = []
}

variable "database_subnets" {
  type        = list(string)
  description = "CIDR blocks for database subnets"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "Tags to apply to all resources"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2view-cloud" }
}

variable "private_subnet_tags" {
  type        = map(any)
  description = "Additional tags for private subnets"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2view-cloud" }
}

variable "public_subnet_tags" {
  type        = map(any)
  description = "Additional tags for public subnets"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2view-cloud" }
}

variable "database_subnet_tags" {
  type        = map(any)
  description = "Additional tags for database subnets"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2view-cloud" }
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT gateway for private subnet outbound traffic"
  default     = true
}

variable "enable_vpn_gateway" {
  type        = bool
  description = "Whether to create a VPN gateway"
  default     = false
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Whether to enable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "Whether to enable DNS support in the VPC"
  default     = true
}
