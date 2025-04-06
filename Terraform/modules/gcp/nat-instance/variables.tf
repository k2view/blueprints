variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = ""
}

variable "subnet" {
  type        = string
  description = "The subnet to create the NAT instance in"
  default     = ""
}

variable "dest_range" {
  type        = string
  description = "Destination IP range"
  default     = ""
}

variable "region" {
  type        = string
  description = "Region for reserved IP"
  default     = ""
}

variable "vpc" {
  type        = string
  description = "VPC for the NAT instance"
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "The type of the NAT instance"
  default     = "e2-medium"
}

variable "nat_instance_fw_ports" {
  type        = list(string)
  description = "Ports to open for a NAT instance"
  default     = ["5432"]
}

variable "nat_instance_ingress_gke" {
  type        = list(string)
  description = "CIDR ranges of GKE pods to allow ingress to NAT instance"
  default     = ["10.176.0.0/14"]
}