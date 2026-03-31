variable "aws_region" {
	type        = string
	description = "AWS region where the EKS cluster is deployed"
	default     = "eu-central-1"
}

variable "cluster_name" {
	type        = string
	description = "EKS cluster name"
}

variable "vpc_subnets" {
	type        = list
	description = "List of VPC subnet IDs for EFS mount targets"
	default     = []
}

variable "vpc_cidr" {
	type        = string
	description = "VPC CIDR block (used for EFS security group ingress rule)"
	default     = "10.0.0.0/16"
}

variable "node_group_role_name" {
	type        = string
	description = "IAM role name of the EKS node group"
	default     = ""
}

# Default tags
variable "common_tags" {
	description = "Tags to apply to all resources"
	type        = map(string)
	default = {
		terraform    = "true"
		env          = "dev"
		project      = "dev"
		owner        = "owner"
	}
}
