variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region of the EKS cluster"
  type        = string
}

variable "domain" {
  description = "Domain filter for Route53 hosted zone"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the cluster OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "Issuer URL of the cluster OIDC provider"
  type        = string
}

variable "txt_owner_id" {
  description = "TXT registry owner ID for ExternalDNS"
  type        = string
}

variable "zone_type" {
  description = "Route53 zone type (public or private)"
  type        = string
  default     = "public"
}

variable "namespace" {
  description = "Namespace for ExternalDNS"
  type        = string
  default     = "kube-system"
}

variable "chart_version" {
  description = "Helm chart version for external-dns"
  type        = string
  default     = "1.20.0"
}
