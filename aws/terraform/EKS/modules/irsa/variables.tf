
variable "tenant" {
    type = string
    description = "Tenant identifier to be used in IAM Role condition"
}

variable "aws_region" {
    type        = string
    description = "The AWS region to run on."
}

variable "cluster_name" {
    type        = string
    description = "EKS Cluster Name"
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
