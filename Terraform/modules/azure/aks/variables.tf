variable "location" {
  type        = string
  description = "Azure region where the AKS cluster and related resources will be created (e.g. 'West Europe')."
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group that will contain the AKS cluster."
}

variable "subnet_id" {
  type        = string
  description = "Resource ID of the existing VNet subnet to attach the AKS node pool to (vnet_subnet_id on the default node pool)."
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster. Also used as the DNS prefix."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for the AKS cluster (e.g. '1.34')."
  default     = "1.34"
}

variable "sku_tier" {
  type        = string
  description = "AKS cluster SKU tier. Options: 'Free', 'Standard', 'Premium'."
  default     = "Standard"
}

variable "zones" {
  type        = list(number)
  description = "Availability zones for the default node pool."
  default     = [1, 2]
}

variable "outbound_type" {
  type        = string
  description = "Outbound routing type for the AKS cluster. Options: 'loadBalancer' (AKS default), 'userAssignedNATGateway' (requires a pre-created NAT gateway), 'userDefinedRouting' (requires a pre-created route table with next-hop IP)."
  default     = "userAssignedNATGateway"
}

variable "vm_sku" {
  type        = string
  description = "Azure VM size for the default node pool (e.g. 'Standard_D8s_v3')."
  default     = "Standard_D8s_v3"
}

variable "system_node_count" {
  type        = number
  description = "Initial node count for the default node pool. Must be between min_size and max_size. Ignored after creation as autoscaling manages the count."
  default     = 1
}

variable "min_size" {
  type        = number
  description = "Minimum number of nodes the autoscaler can scale the default node pool down to."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of nodes the autoscaler can scale the default node pool up to."
  default     = 3
}

variable "kubeconfig_file_path" {
  type        = string
  description = "Local filesystem path where the kubeconfig file will be written after cluster creation. Leave empty to skip writing the file."
  default     = ""
}

variable "private_cluster_enabled" {
  type        = bool
  description = "When true, the AKS API server is only reachable from within the VNet (private cluster). Note: Helm-based modules (ingress controller, k2view-agent) cannot reach a private API server and must be deployed separately."
  default     = false
}

variable "acr_id" {
  type        = string
  description = "Resource ID of the Azure Container Registry to grant AcrPull access to. The kubelet managed identity of the cluster is assigned the AcrPull role on this ACR."
  default     = ""
}

variable "tags" {
  type        = map(any)
  description = "Tags to apply to all resources created by this module."
  default     = { Env = "Dev", Owner = "owner_name", Project = "k2v_cloud" }
}
