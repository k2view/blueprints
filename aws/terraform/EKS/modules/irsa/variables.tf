variable "aws_region" {
    type        = string
    description = "The AWS region to run on."
}

variable "cluster_name" {
    type        = string
    description = "EKS Cluster Name"
}

variable "include_s3_permissions" {
  description = "Whether to include S3 permissions in the policy"
  type        = bool
  default     = true
}

variable "include_cassandra_permissions" {
  description = "Whether to include Cassandra permissions in the policy"
  type        = bool
  default     = true
}

variable "include_rds_permissions" {
  description = "Whether to include RDS permissions in the policy"
  type        = bool
  default     = true
}

# Default tags
variable "owner" {
    type        = string
    description = "Owner name for tag."
}

variable "project" {
    type        = string
    description = "Project name for tag."
}

variable "env" {
    type        = string
    description = "Environment for tag (Dev/QA/Prod)."
}
