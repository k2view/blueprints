variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The GCP region"
  default     = "europe-west3"
}

variable "k2view_agent_namespace" {
  type        = string
  description = "The name of K2view agent namespace"
  default     = "k2view-agent"
}

# Grafana agent
variable "deploy_grafana_agent" {
  type        = bool
  description = "A boolean flag to control whether to install grafana agent"
  default     = false
}

variable "grafana_token" {
  type        = string
  description = "An Access Policy token is required for Grafana Alloy to send metrics and logs to Grafana Cloud"
  default     = ""
}

# Network
variable "network_name" {
  type        = string
  description = "The name of the network"
  default     = ""
}

variable "subnet_cidr" {
  type        = string
  description = "Primary CIDR range for a subnet"
  default     = "10.130.0.0/20"
}

variable "secondary_cidr_pods" {
  type        = string
  description = "Secondary CIDR range for pods"
  default     = "10.176.0.0/18"
}

variable "secondary_cidr_services" {
  type        = string
  description = "Secondary CIDR range for services"
  default     = "10.180.0.0/20"
}

variable "nat_subnet_cidr" {
  type        = string
  description = "Primary CIDR range for a PROD subnet"
  default     = "10.133.0.0/26"
}

# Firewall
variable "whitelist_enabled" {
  description = "Enable IP whitelisting"
  type        = bool
  default     = false
}

variable "whitelist_ips" {
  description = "List of IP ranges to whitelist"
  type        = list(string)
  default     = [""]
}

# GKE
variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "regional" {
  type        = bool
  description = "A boolean flag to control whether GKE cluster is regional or zonal"
  default     = true
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the GKE cluster"
  default     = "1.28"
}

variable "machine_type" {
  type        = string
  description = "The GCP VM type for cluster workers"
  default     = "e2-highmem-4"
}

variable "min_node" {
  type        = number
  description = "The minimum workers up"
  default     = 1
}

variable "max_node" {
  type        = number
  description = "The maximum workers up"
  default     = 3
}

variable "initial_node_count" {
  type        = number
  description = "The initial workers up"
  default     = 1
}

variable "disk_size_gb" {
  type        = number
  description = "The disk size for cluster workers"
  default     = 500
}

variable "disk_type" {
  type        = string
  description = "The disk type for cluster workers"
  default     = "pd-standard"
}

variable "zones" {
  type        = list(string)
  description = "Zones for GKE master and worker nodes"
  default     = ["a", "b"]
}

## Deployments
variable "domain" {
  type        = string
  description = "The domain will be used for ingress"
}

# Ingress
variable "keyPath" {
  type        = string
  description = "Path to the TLS key file."
  default     = ""
}

variable "certPath" {
  type        = string
  description = "Path to the TLS cert file."
  default     = ""
}

variable "enable_private_lb" {
  type        = bool
  description = "Flag to enable or disable private load balancer IP"
  default     = false
}

# K2view agent
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

# NAT Instance
variable "create_nat_instnace" {
  type        = bool
  description = "A boolean flag to control whether to create NAT instance"
  default     = false
}

variable "nat_dest_range" {
  type        = string
  description = "NAT instance destination IP range for routing"
}

variable "nat_dest_ports" {
  type        = list(string)
  description = "NAT instance destination ports"
}