variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "subnet_id" {
  type        = string
  description = "Virtual network subnet ID for existing Vnet"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version."
  default     = "1.30"
}

variable "outbound_type" {
  type        = string
  description = "Outbound Type"
  default     = "userAssignedNATGateway" # loadBalancer (default for AKS) or userAssignedNATGateway (create_nat_gateway=true) or userDefinedRouting (The user should create the routing and add route_table_next_hop_ip)
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

variable "private_cluster_enabled" {
  type        = bool
  description = "hould this Kubernetes Cluster have its API server only exposed on internal IP addresses?"
  default     = false # If set to true modules that deploy helm to the cluster will fail (like AKS_ingress and AKS_k2v_agent) and will be needed be deployed manually
}

variable "acr_id" {
  type = string
  description = "The ID of the ACR to attach"
  default = ""
}

variable "tags" {
  type        = map(any)
  description = "Tags value"
  default     = { Env = "Dev", Owner = "k2view", Project = "k2vDev" }
}