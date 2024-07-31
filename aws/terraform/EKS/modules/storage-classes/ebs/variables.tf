variable "encrypted" {
  description = "Flag to enable or disable EFS module"
  type        = bool
  default     = true
}

variable "node_group_iam_role" {
  description = "Flag to enable or disable EFS module"
  type        = string
}