variable "encrypted" {
  description = "Whether to encrypt EBS volumes"
  type        = bool
  default     = true
}

variable "node_group_iam_role" {
  description = "IAM role name of the EKS node group (the EBS CSI policy will be attached to this role)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}
