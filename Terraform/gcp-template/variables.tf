variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The GCP region"
  default     = "europe-west3"
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "domain" {
  type        = string
  description = "The domain will be used for ingress"
}

# GKE
variable "regional" {
  type        = bool
  description = "A boolean flag to control whether GKE cluster is regional or zonal"
  default     = true
}

variable "gke_kubernetes_version" {
  type        = string
  description = "Kubernetes version of the GKE cluster"
  default     = "1.32"
}

variable "gke_worker_machine_type" {
  type        = string
  description = "The GCP VM type for cluster workers"
  default     = "e2-highmem-8"
}

variable "gke_min_worker_count" {
  type        = number
  description = "The minimum workers up"
  default     = 1
}

variable "gke_max_worker_count" {
  type        = number
  description = "The maximum workers up"
  default     = 3
}

variable "gke_initial_worker_count" {
  type        = number
  description = "The initial workers up"
  default     = 1
}

variable "gke_worker_disk_size" {
  type        = number
  description = "The disk size for cluster workers"
  default     = 500
}

variable "gke_worker_disk_type" {
  type        = string
  description = "The disk type for cluster workers"
  default     = "pd-standard"
}

# Network
variable "zones" {
  type        = list(string)
  description = "Zones for GKE master and worker nodes"
  default     = ["a", "b"]
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

# NAT Instance
variable "create_nat_instance" {
  type        = bool
  description = "A boolean flag to control whether to create NAT instance"
  default     = false
}

variable "nat_dest_range" {
  type        = string
  description = "NAT instance destination IP range for routing"
  default     = ""
}

variable "nat_dest_ports" {
  type        = list(string)
  description = "NAT instance destination ports"
  default     = [""]
}

variable "nat_instance_ingress" {
  type        = list(string)
  description = "CIDR ranges for NAT instance ingress"
  default     = ["0.0.0.0/0"]
}

# Ingress Controller
variable "ingress_controller_key_b64" {
  type        = string
  description = "Path to the TLS key file."
  default     = ""
}

variable "ingress_controller_cert_b64" {
  type        = string
  description = "Path to the TLS cert file."
  default     = ""
}

variable "ingress_controller_enable_private_lb" {
  type        = bool
  description = "Flag to enable or disable private load balancer IP"
  default     = false
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

variable "deploy_secret_store_csi" {
  type        = bool
  description = "A boolean flag to control whether to deploy secret store csi "
  default     = false
}