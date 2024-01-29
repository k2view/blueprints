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