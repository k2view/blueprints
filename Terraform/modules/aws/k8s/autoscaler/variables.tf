variable "cluster_name" {
  type        = string
}

variable "region" {
  type        = string
}

variable "role" {
  description = "The ARN of the IAM role to attach the policy to"
  type        = string
}