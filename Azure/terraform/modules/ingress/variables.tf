variable "nginx_namespace" {
  type        = string
  description = "Kubernetes namespace for nginx"
  default     = "ingress-nginx"
}

variable "domain" {
  type        = string
  description = "the domain will be used for ingress"
}

variable "cluster_name" {
  type        = string
  description = "The AKS cluster name"
}
