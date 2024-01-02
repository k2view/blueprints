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
