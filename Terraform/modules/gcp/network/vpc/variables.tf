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
  description = "CIDR range for the NAT subnet"
  default     = "10.133.0.0/26"
}

variable "gcp_console_access_cidr" {
  type        = string
  description = "GCP Cloud Shell CIDR range allowed for SSH access to the NAT instance"
  default     = "35.235.240.0/20"
}

