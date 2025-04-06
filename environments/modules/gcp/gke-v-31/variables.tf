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

variable "regional" {
  type        = bool
  description = "A boolean flag to control whether GKE cluster is regional or zonal"
  default     = true
}

variable "network_name" {
  type        = string
  description = "The name of the network"
  default     = ""
}

variable "subnet_name" {
  type        = string
  description = "The name of the network"
  default     = ""
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

variable "storage_class_type" {
  type        = string
  description = "The type of the storage class"
  default     = "pd-balanced"
}

variable "zones" {
  type        = list(string)
  description = "Zones for GKE master and worker nodes"
  default     = ["a", "b"]
}