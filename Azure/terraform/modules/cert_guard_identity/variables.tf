variable "subscription_id" {
  type        = string
  description = "Subscription id in Azure"
  default     =  ""
}

variable "identity_name" {
  type        = string
  description = "Identity name"
  default     =  "cert-guardian"
}

variable "location" {
  type        = string
  description = "Resource region"
  default     =  ""
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
  default     =  ""
}

variable "namespace" {
  type        = string
  description = "K8s service namespace"
  default     =  "ingress-nginx"
}

variable "service_account_name" {
  type        = string
  description = "K8s service account name"
  default     =  "k2view-cert-guardian-sa"
}

variable "kubernetes_oidc_issuer_url" {
  type        = string
  description = "K8s Cluster OIDC Issuer URL, required"
  default     =  ""
}

variable "dns_zone_name" {
  type        = string
  description = "Azure DNS zone name, required"
  default     =  ""
}