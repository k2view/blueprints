# RG
variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "create_resource_group" {
  type        = bool
  description = "Create RG name in Azure"
  default     = true
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

# Network
variable "virtual_network_address_space" {
  type        = string
  description = "Virtual network address space CIDR"
  default     = "10.0.0.0/8"
}

variable "subnet_address_prefixes" {
  type        = string
  description = "Virtual network subnet address prefixes CIDR"
  default     = "10.240.0.0/16"
}

# Cluster
variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version."
  default     = "1.27.7"
}

variable "vm_sku" {
  type        = string
  description = "VM sku"
  default     = "Standard_D8s_v3"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes (min_size <= system_node_count <= max_size)."
  default     = 1
}

variable "min_size" {
  type        = number 
  description = "Minimum cluster size"
  default     = 1
}

variable "max_size" {
  type        = number 
  description = "Maximum cluster size"
  default     = 3
}

variable "kubeconfig_file_path" {
  type        = string
  description = "Path for kubeconfig file"
  default     = ""
}

# Grafana agent
variable "deploy_grafana_agent" {
  type        = bool
  description = "A boolean flag to control whether to install grafana agent"
  default     = false
}

# Global
variable "tags" {
  type        = map
  description = "Tags value"
  #tags        = { Env = "Dev", Owner = "k2view", Project = "k2vDev" }
}

variable "domain" {
  type        = string
  description = "the domain will be used for ingress"
}

