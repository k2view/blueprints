variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "domain" {
  type        = string
  description = "The domain will be used for ingress"
}

variable "name" {
  type        = string
  description = "The DNS Zone name"
}

variable "lb_ip" {
  type        = string
  description = "IP of Load Balancer that point to this cluster."
}