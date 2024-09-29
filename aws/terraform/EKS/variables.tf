variable "domain" {
  type        = string
  description = "The domain will be used for ingress"
}

variable "region" {
  type        = string
  description = "The region of the cluster"
}

variable "network_name" {
  type        = string
  description = "The name of the network"
  default     = ""
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR range of the network"
  default     = "10.0.0.0/16"
}

variable "zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["a", "b"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# EKS
variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the GKE cluster"
  default     = "1.30"
}

variable "instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = ["m5.2xlarge"]
}

variable "efs_enabled" {
  description = "Flag to enable or disable EFS module"
  type        = bool
  default     = false
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

variable "desired_size" {
  type        = number
  description = "The desired number of workers"
  default     = 1
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

variable "k2view_agent_namespace" {
  type        = string
  description = "The name of K2view agent namespace"
  default     = "k2view-agent"
}

# Tags
variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform    = "true"
    env          = "dev"
    project      = "dev"
    owner        = "k2v-devops"
    customer     = "k2view"
  }
}