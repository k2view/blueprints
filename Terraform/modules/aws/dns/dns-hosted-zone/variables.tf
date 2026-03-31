variable "cluster_name" {
  type        = string
  description = "EKS cluster name (used for resource naming)"
}

variable "domain" {
  type        = string
  description = "Domain name for the Route 53 hosted zone and ACM certificate"
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    terraform    = "true"
    env          = "dev"
    project      = "k2v_cloud"
    owner        = "owner"
  }
}

variable "create_parent_zone_records" {
  description = "Whether to create NS records in the parent hosted zone (set to false if the parent zone is not managed here)"
  type        = bool
  default     = false
}
