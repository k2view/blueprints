variable "project_id" {
  type        = string
  description = "GCP Project."
}

variable "region" {
  type        = string
  description = "GCP Region."
  default     = "europe-west3"
}

variable "cluster_name" {
  type        = string
  description = "GKE cluster name for resources name."
}

variable "domain" {
  type        = string
  description = "Subdomain for cloud DNS."
}

variable "lb_ip" {
  type        = string
  description = "IP of Load Balancer that point to this cluster."
}

### Default tags ###
variable "owner" {
  type        = string
  description = "Owner name for tag."
  default     = "k2view"
}

variable "project" {
  type        = string
  description = "Project name for tag, if cluster name will be empty it will replace cluster name in the names."
  default     = "k2view-fabric"
}

variable "env" {
  type        = string
  description = "Environment for tag (Dev/QA/Prod)."
  default     = "Dev"
}
