variable "resource_group_name" {
  type        = string
  description = "Resource Group name in Azure"
}

variable "create_resource_group" {
  type        = bool
  description = "Create Resource Group in Azure"
  default     = false
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}            

variable "domain" {
  type        = string
  description = "The domain that will be used for DNS zone"
}

variable "record_ip" {
  type        = string
  description = "The IP of the record to add"
  default     = ""
}

variable "dns_record_name" {
  type        = string
  description = "The DNS record name"
  default     = "*"
}

variable "tags" {
  type        = map
  description = "Tags values"
  #tags={ Env = "Dev", Owner = "k2view", Project = "k2vDev" }
}
