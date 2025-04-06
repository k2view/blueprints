variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The GCP region"
  default     = "europe-west3"
}

variable "network_name" {
  type        = string
  description = "The name of the network"
  default     = ""
}

# DEV
variable "dev_subnet_cidr" {
  type        = string
  description = "Primary CIDR range for a DEV subnet"
  default     = "10.130.0.0/20"
}

variable "dev_secondary_cidr_pods" {
  type        = string
  description = "Secondary CIDR range for DEV GKE pods"
  default     = "10.176.0.0/18"
}

variable "dev_secondary_cidr_services" {
  type        = string
  description = "Secondary CIDR range for DEV GKE services"
  default     = "10.176.64.0/20"
}
# STAGING
variable "staging_subnet_cidr" {
  type        = string
  description = "Primary CIDR range for a STAGING subnet"
  default     = "10.130.0.0/20"
}

variable "staging_secondary_cidr_pods" {
  type        = string
  description = "Secondary CIDR range for STAGING GKE pods"
  default     = "10.176.0.0/18"
}

variable "staging_secondary_cidr_services" {
  type        = string
  description = "Secondary CIDR range for STAGING GKE services"
  default     = "10.176.64.0/20"
}
# PROD
variable "prod_subnet_cidr" {
  type        = string
  description = "Primary CIDR range for a PROD subnet"
  default     = "10.130.0.0/20"
}

variable "prod_secondary_cidr_pods" {
  type        = string
  description = "Secondary CIDR range for PROD GKE pods"
  default     = "10.176.0.0/18"
}

variable "prod_secondary_cidr_services" {
  type        = string
  description = "Secondary CIDR range for PROD GKE services"
  default     = "10.176.64.0/20"
}
# NAT
variable "nat_subnet_cidr" {
  type        = string
  description = "Primary CIDR range for a PROD subnet"
  default     = "10.130.0.0/20"
}
