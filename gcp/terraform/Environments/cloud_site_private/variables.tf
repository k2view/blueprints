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

variable "deploy_grafana_agent" {
  type        = bool
  description = "A boolean flag to control whether to install grafana agent"
  default     = false
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
  default     = "10.130.0.0/16"
}

variable "secondary_cidr_pods" {
  type        = string
  description = "Secondary CIDR range for pods"
  default     = "10.176.0.0/14"
}

variable "secondary_cidr_services" {
  type        = string
  description = "Secondary CIDR range for services"
  default     = "10.180.0.0/20"
}

# GKE
variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
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

## Deployments
variable "domain" {
  type        = string
  description = "The domain will be used for ingress"
}
