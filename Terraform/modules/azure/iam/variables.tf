variable "cluster_name" {
    type = string
    description = "AKS cluster name"
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "West Europe"
}

variable "aks_principal_id" {
    type = string
    description = "Principal ID of the AKS cluster's managed identity"
}

variable "subnet_id" {
    type = string
    description = "Subnet ID for the AKS cluster"
}

variable "kubernetes_oidc_issuer_url" {
    type = string
    description = "OIDC issuer URL of the AKS cluster (used for workload identity federation)"
}

variable "k2view_agent_namespace" {
    type = string
    description = "Kubernetes namespace for the K2view agent"
    default = "k2view-agent"
}
