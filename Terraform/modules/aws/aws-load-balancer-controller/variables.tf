variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster resides"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the cluster OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "Issuer URL of the cluster OIDC provider"
  type        = string
}

variable "chart_version" {
  description = "Helm chart version for aws-load-balancer-controller"
  type        = string
  default     = "3.1.0"
}
