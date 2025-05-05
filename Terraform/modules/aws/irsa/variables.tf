variable "aws_region" {
    type        = string
    description = "The AWS region to run on."
}

variable "cluster_name" {
    type        = string
    description = "EKS Cluster Name"
}

variable "include_s3_space_permissions" {
  description = "Whether to include S3 permissions in the space policy"
  type        = bool
  default     = true
}

variable "include_cassandra_space_permissions" {
  description = "Whether to include Cassandra permissions in the space policy"
  type        = bool
  default     = true
}

variable "include_rds_space_permissions" {
  description = "Whether to include RDS permissions in the space policy"
  type        = bool
  default     = true
}

variable "include_msk_space_permissions" {
  description = "Whether to include MSK permissions in the space policy"
  type        = bool
  default     = true  
}

variable "include_opensearch_space_permissions" {
  description = "Whether to include opensearch permissions in the space policy"
  type        = bool
  default     = true  
}

variable "include_secret_manager_space_permissions" {
  description = "Whether to include secret manager permissions in the space policy"
  type        = bool
  default     = true
}

variable "include_common_deployer_permissions" {
  description = "Whether to include common permissions in the deployer policy"
  type        = bool
  default     = true
}

variable "include_s3_deployer_permissions" {
  description = "Whether to include S3 permissions in the deployer policy"
  type        = bool
  default     = true
}

variable "include_cassandra_deployer_permissions" {
  description = "Whether to include Cassandra permissions in the deployer policy"
  type        = bool
  default     = true
}

variable "include_rds_deployer_permissions" {
  description = "Whether to include RDS permissions in the deployer policy"
  type        = bool
  default     = true
}

variable "include_msk_deployer_permissions" {
  description = "Whether to include MSK permissions in the deployer policy"
  type        = bool
  default     = true  
}

# # Tags
variable "common_tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform    = "true"
    map-migrated = "mig42452"
    env          = "dev"
    project      = "dev"
    owner        = "k2v-devops"
    customer     = "k2view"
  }
}