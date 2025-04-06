variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster."

}
variable "eks_cluster_version" {
  type        = string
  description = "The version of the EKS cluster."
  default     = "1.30"
}

variable "eks_cluster_endpoint_public_access" {
  type        = bool
  description = "Indicates whether the Amazon EKS cluster endpoint is publicly accessible. When set to true, the endpoint can be accessed from outside of the VPC. When set to false, the endpoint can only be accessed from within the VPC."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC in which to create the EKS cluster."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs in which to place the worker nodes."
}

variable "control_plane_subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs in which to place the control plane."
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
    aws-efs-csi-driver = {
      most_recent = true
    }
  }
}

variable "eks_instance_types" {
  type        = list(string)
  description = "A list of EC2 instance types to use for the worker nodes."
  default     = ["t3.medium"]
}

variable "ami_type" {
  type        = string
  description = "The AMI type to use for the worker nodes."
  default     = "AL2_x86_64"
}

variable "min_size" {
  type        = number
  description = "The minimum number of worker nodes to create."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "The maximum number of worker nodes to create."
  default     = 3
}

variable "desired_size" {
  type        = number
  description = "The desired number of worker nodes to create."
  default     = 2
}

variable "access_entries" {
  type        = map(any)
  description = "The access entries to use for the EKS cluster."
  default     = {}
}

variable "enable_cluster_creator_admin_permissions" {
  type        = bool
  description = "Whether to enable cluster creator admin permissions."
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "authentication_mode" {
  type        = string
  description = "The authentication mode to use for the EKS cluster."
  default     = "API"
}

variable "capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "disk_size" {
  type    = number
  default = 100
}

variable "disk_type" {
  type    = string
  default = "gp3"
}

variable "disk_iops" {
  type    = number
  default = 3000
}

variable "disk_throughput" {
  type    = number
  default = 125
}

variable "disk_encryption_enabled" {
  type    = bool
  default = true
}
variable "custom_kms_key_arn" {
  description = "The ARN of the KMS key to use for EBS encryption. If not provided, the default EBS encryption key will be used."
  type        = string
  default     = null
}