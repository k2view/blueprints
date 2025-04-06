variable "cluster_name" {
    type = string
    description = "The name of the K8S cluster"
}

variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "aks_principal_id" {
    type = string
    description = "Principal ID of the K8S cluster"
}

variable "subnet_id" {
    type = string
    description = "Virtual network subnet ID"
}

variable "kubernetes_oidc_issuer_url" {
    type = string
    description = "K8S OIDC URL"
}

variable "k2view_agent_namespace" {
    type = string
    description = "K2view agent namespace name"
    default = "k2view-agent"
}