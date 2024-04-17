variable "aso_namespace" {
  type        = string
  description = "the namespace used by Azure Service Operator"
}
variable "subscription" {
  type        = string
  description = "Azure subscription"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
}

variable "node_resource_group" {
  type        = string
  description = "RG name created by AKS"
}

variable "oidc_issuer_url" {
  type        = string
  description = "The URL of OIDC Issuer"
}

variable "aks_public_ip" {
  type        = string
  description = "The public IP address of the AKS private network"
}

variable "k2agent_config" {
  type        = bool
  description = "Deploy additional configuration on K2view Agent"
}
