variable "oidc_provider" {
  type        = string
  description = "EKS oidc provider"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
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
