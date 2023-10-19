variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "The AWS region to run on"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_version" {
  type        = string
  default     = "1.27"
  description = "EKS cluster version"
}

variable "instance_type" {
  type        = string
  default     = "m5.2xlarge"
  description = "EKS cluster instance type"
}

variable "domain" {
  type        = string
  description = "Subdomain for rout53 (Example SUBDOMAIN.DOMAIN.COM)"
}

### Default tags ###

variable "owner" {
  type        = string
  description = "Owner Tag value"
}

variable "project" {
  type        = string
  description = "Project Tag value"
}

variable "env" {
  type        = string
  description = "Environment Tag value (Dev/QA/Prod)"
}
