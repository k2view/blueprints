variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "domain" {
  type        = string
  description = "Domain name for the Cloud DNS public zone"
}

variable "name" {
  type        = string
  description = "Cloud DNS managed zone name"
}

variable "lb_ip" {
  type        = string
  description = "IP address of the load balancer to point DNS records at"
}
