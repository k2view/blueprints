variable "aws_region" {
  type        = string
  description = "The AWS region to run on"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "domain" {
  type        = string
  description = "Subdomain for rout53 (Example SUBDOMAIN.DOMAIN.COM)"
}

variable "karpenter_cloudformation_path" {
  type = string
  default = "./cloudformations/karpenter.yaml"
  description = "local Path to Karpenter Cloudformation stack - cloudformation from : https://karpenter.sh/docs/getting-started/getting-started-with-karpenter/"
}

variable "karpenter_version" {
  type = string
  default = "v0.29.2"
  description = "The version of Karpenter to be installed"
}


### Default tags ###

variable "owner" {
  type        = string
  description = "Owner Tag value"
}

variable "project" {
  type        = string
  description = "Project Tag value"
}

variable "env" {
  type        = string
  description = "Environment Tag value (Dev/QA/Prod)"
}
