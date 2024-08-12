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
    project      = "dev"
    owner        = "owner"
  }
}