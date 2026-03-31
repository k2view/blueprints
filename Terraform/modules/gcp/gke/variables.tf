variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region for the cluster"
  default     = "europe-west3"
}

variable "cluster_name" {
  type        = string
  description = "GKE cluster name"
}

variable "regional" {
  type        = bool
  description = "Whether the cluster is regional (true) or zonal (false)"
  default     = true
}

variable "network_name" {
  type        = string
  description = "VPC network name to deploy the cluster into"
  default     = ""
}

variable "subnet_name" {
  type        = string
  description = "Subnet name to deploy the cluster into"
  default     = ""
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the GKE cluster"
  default     = "1.34"
}

variable "machine_type" {
  type        = string
  description = "GCE machine type for worker nodes"
  default     = "e2-highmem-4"
}

variable "min_node" {
  type        = number
  description = "Minimum number of worker nodes per zone"
  default     = 1
}

variable "max_node" {
  type        = number
  description = "Maximum number of worker nodes per zone"
  default     = 3
}

variable "initial_node_count" {
  type        = number
  description = "Initial number of worker nodes per zone"
  default     = 1
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB for worker nodes"
  default     = 500
}

variable "disk_type" {
  type        = string
  description = "Boot disk type for worker nodes (e.g. pd-standard, pd-ssd)"
  default     = "pd-standard"
}

variable "storage_class_type" {
  type        = string
  description = "GCP persistent disk type for the default storage class (e.g. pd-balanced, pd-ssd)"
  default     = "pd-balanced"
}

variable "zones" {
  type        = list(string)
  description = "Zone suffixes for GKE nodes (e.g. [\"a\", \"b\"] → europe-west3-a, europe-west3-b)"
  default     = ["a", "b"]
}
