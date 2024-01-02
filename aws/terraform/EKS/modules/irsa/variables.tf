
variable "tenant" {
    type = string
    description = "Tenant identifier to be used in IAM Role condition"
    default = "k2view"
}


variable "aws_region" {
    type        = string
    description = "The AWS region to run on."
    default     = "eu-central-1"
}

variable "cluster_name" {
    type        = string
    description = "EKS Cluster Name"
}

# Default tags
variable "owner" {
    type        = string
    description = "Owner name for tag."
    default     = "Itay Almani"
}

variable "project" {
    type        = string
    description = "Project name for tag, if cluster name will be empty it will replace cluster name in the names."
    default     = "RnD"
}

variable "env" {
    type        = string
    description = "Environment for tag (Dev/QA/Prod)."
    default     = "Dev"
}
