variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "region" {
  type        = string
  description = "AWS region where the EKS cluster is deployed"
}

variable "role" {
  description = "IAM role name to attach the cluster autoscaler policy to"
  type        = string
}
