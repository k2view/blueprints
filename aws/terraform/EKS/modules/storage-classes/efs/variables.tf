variable "aws_region" {
	type        = string
	description = "The AWS region to run on."
	default     = "eu-central-1"
}

variable "cluster_name" {
	type        = string
	description = "EKS Cluster Name"
}

variable "vpc_subnets" {
	type        = list
	description = "vpc_subnets can be supploed - this must be used when this is used as a module"
	default     = []
}

variable "vpc_cidr" {
	type        = string
	description = "CIDR block to be assigned to vpc"
	default     = "10.0.0.0/16"
}

variable "node_group_role_name" {
	type        = string
	description = "EKS Cluster node group role name"
	default     = ""
}

# Default tags
variable "common_tags" {
	description = "A map of tags to assign to the resources"
	type        = map(string)
	default = {
		terraform    = "true"
		env          = "dev"
		project      = "dev"
		owner        = "owner"
	}
}