variable "repository_name" {
  type        = string
  description = "The name of the ECR repository."
}

variable "repository_read_write_access_arns" {
  type        = list(string)
  description = "A list of IAM ARNs that will have read and write access to the ECR repository." 
}


variable "tags" {
  type        = map(string)
  description = "A map of tags to add to the ECR repository."
  default     = {}
}
