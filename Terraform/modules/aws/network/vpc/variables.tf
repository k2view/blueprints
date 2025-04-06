variable "vpc_name" {
    type = string
    description = "vpc name"
    default = ""
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr"
  default     = ""
}

variable "availability_zones" {
  type        = list(string)
  description = "list of the availability zones"
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "list of the private subnets"
  default     = []
}

variable "public_subnets" {
  type        = list(string)
  description = "list of the public subnets"
  default     = []
}

variable "database_subnets" {
  type        = list(string)
  description = "list of the database subnets"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "Tags value"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2view-cloud" }
}

variable "private_subnet_tags" {
  type        = map(any)
  description = "Tags value"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2view-cloud" }
}

variable "public_subnet_tags" {
  type        = map(any)
  description = "Tags value"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2view-cloud" }
} 

variable "database_subnet_tags" {
  type        = map(any)
  description = "Tags value"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2view-cloud" }
}

variable "enable_nat_gateway" {
  type        = bool
  description = "enable nat gateway"
  default     = true
}

variable "enable_vpn_gateway" {
  type        = bool

  description = "enable vpn gateway"
  default     = false
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "enable dns support"
  default     = true
}

