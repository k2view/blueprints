variable "aws_region" {
    type        = string
    description = "The AWS region to run on."
    default     = "eu-central-1"
}

variable "cluster_name" {
    type        = string
    description = "EKS Cluster Name"
}

variable "default_value" {
    type        = string
    description = "The following value is a default value in order for terraform to apply (This i only used when in module mode)"
    default     = 3
}

variable "vpc_subnets" {
    type        = list
    description = "vpc_subnets can be supploed - this must be used when this is used as a module"
    default     = []
}

variable "vpc_cidr" {
    type        = string
    description = "cidr block to be assigned to vpc"
    default     = "10.0.0.0/16"
}

variable "node_group_role_name" {
    type        = string
    description = "EKS Cluster node group role name"
    default     = ""
}

# Default tags
variable "owner" {
    type        = string
    description = "Owner name for tag."
}

variable "project" {
    type        = string
    description = "Project name for tag, if cluster name will be empty it will replace cluster name in the names."
}

variable "env" {
    type        = string
    description = "Environment for tag (Dev/QA/Prod)."
    default     = "Dev"
}
