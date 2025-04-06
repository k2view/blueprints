### EKS ###
variable "cluster_name" {
  type        = string
  description = "EKS cluster name for resources name."
}

variable "domain" {
  type        = string
  description = "Subdomain for rout53."
}

### Default tags ###
variable "common_tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform    = "true"
    env          = "dev"
    project      = "k2v_cloud"
    owner        = "owner"
  }
}

variable "create_parent_zone_records" {
  description = "Whether to create NS records in the parent hosted zone. Set to false if parent zone doesn't exist or if you don't want to manage it."
  type        = bool
  default     = false
}
