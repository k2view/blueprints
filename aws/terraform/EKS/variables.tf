variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "The AWS region to run on"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_version" {
  type        = string
  default     = "1.27"
  description = "EKS cluster version"
}

variable "domain" {
  type        = string
  description = "Subdomain for rout53 (Example SUBDOMAIN.DOMAIN.COM)"
}

variable "karpenter_cloudformation_path" {
  type        = string
  default     = "./cloudformations/karpenter.yaml"
  description = "local Path to Karpenter Cloudformation stack - Ref : https://karpenter.sh/docs/getting-started/getting-started-with-karpenter/"
}

variable "karpenter_version" {
  type        = string
  default     = "v0.29.2"
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
