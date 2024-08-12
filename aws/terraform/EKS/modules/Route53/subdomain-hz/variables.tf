variable "cluster_name" {
	type        = string
	description = "EKS cluster name for resources name."
}

variable "domain" {
	type        = string
	description = "Subdomain for rout53."
}

variable "update_parent_hosted_zone" {
	type        = bool
	description = "Create A recort in parent hosted zone that point to new hosted zone"
	default     = false
}

### Default tags ###
variable "owner" {
	type        = string
	description = "Owner name for tag."
}

variable "project" {
	type        = string
	description = "Project name for tag, if cluster name will be empty it will replace cluster name in the names."
}

variable "env" {
	type        = string
	description = "Environment for tag (Dev/QA/Prod)."
	default     = "Dev"
}
