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
variable "create_network" {
  type        = bool
  description = "Create Vnet for the AKS cluster"
  default     = true
}

variable "prefix_name" {
  type        = string
  description = "Prefix name for networks"
  default     = ""
}

variable "create_nat_gateway" {
  type        = bool
  description = "Create NAT gateway."
  default     = true
}

variable "create_route_table" {
  type        = bool
  description = "Create route table as a gateway."
  default     = false
}

variable "route_table_next_hop_ip" {
  type        = string
  description = "IP address of the next hop in the routing table."
  default     = ""
}

variable "virtual_network_address_space" {
  type        = string
  description = "Virtual network address space CIDR"
  default     = "10.0.0.0/8" #minimal /24
}

variable "subnet_address_prefixes" {
  type        = string
  description = "Virtual network subnet address prefixes CIDR"
  default     = "10.240.0.0/16" #minimal /26
}

variable "subnet_id" {
  type        = string
  description = "Virtual network subnet ID for existing Vnet"
  default     = ""
}

# Cluster
variable "create_acr" {
  type        = bool
  description = "Create ACR in Azure"
  default     = true
}

variable "acr_name" {
  type        = string
  description = "ACR name in Azure (Resource names may contain alpha numeric characters only and must be between 5 and 50 characters, needs to be globally unique.)"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
  default     = ""
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version."
  default     = "1.32"
}

variable "outbound_type" {
  type        = string
  description = "Kubernetes version."
  default     = "userAssignedNATGateway" # loadBalancer (default for AKS) or userAssignedNATGateway (create_nat_gateway=true) or userDefinedRouting (The user should create the routing and add route_table_next_hop_ip)
}

variable "vm_sku" {
  type        = string
  description = "VM sku"
  default     = "E8as_v5"
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

# Ingress
variable "domain" {
  type        = string
  description = "The domain will be used for ingress"
}

variable "delay_command" {
  type        = string
  description = "The command for delay (depend on the env)."
  default     = "sleep 60" #"sleep 60" for linux, for windows is "powershell -Command Start-Sleep -Seconds 60"
}

variable "ingress_controller_enable_private_lb" {
  type        = bool
  description = "Flag to enable or disable private load balancer IP"
  default     = false
}

variable "deploy_ingress" {
  type        = bool
  description = "Deploy nginx ingress in the cluster"
  default     = true
}

variable "ingress_controller_key_b64" {
  type        = string
  description = "Ingress Controller TLS key base64 encoded"
  default     = ""
}

variable "ingress_controller_cert_b64" {
  type        = string
  description = "Ingress Controller TLS certificate base64 encoded"
  default     = ""
}

variable "lb_ip" {
  type        = string
  description = "LB IP for the DNS to point to"
  default     = ""
}

# DNS
variable "create_dns" {
  type        = bool
  description = "Create DNS zone in Azure that point all the trafic to the LB"
  default     = true
}

# K2view agent
variable "k2view_agent_namespace" {
  type        = string
  description = "The name of K2view agent namespace"
  default     = "k2view-agent"
}

variable "mailbox_id" {
  type        = string
  description = "k2view cloud mailbox ID."
  default     = ""
}

variable "mailbox_url" {
  type        = string
  description = "k2view cloud mailbox URL."
  default     = "https://cloud.k2view.com/api/mailbox"
}

# Global
variable "tags" {
  type        = map(string)
  description = "Tags value"
  default     = { Env = "Dev", Owner = "owner_name", Project = "k2v_cloud" }
}