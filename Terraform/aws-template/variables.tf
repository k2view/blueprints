variable "domain" {
  type        = string
  description = "The domain will be used for ingress"
}

variable "region" {
  type        = string
  description = "The region of the cluster"
  default     = "eu-central-1"
}

variable "network_name" {
  type        = string
  description = "The name of the network"
  default     = ""
}

variable "private_cluster" {
  type        = bool
  description = "Flag to enable or disable private cluster"
  default     = false
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR range of the network"
  default     = "10.5.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["euc1-az1", "euc1-az2"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.5.3.0/24", "10.5.4.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.5.1.0/24", "10.5.2.0/24"]
}

variable "database_subnets" {
  description = "List of subnet CIDRs"
  type        = list(string)
  default     = ["10.5.5.0/24", "10.5.6.0/24"]
}

# EKS
variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the GKE cluster"
  default     = "1.32"
}

variable "eks_cluster_endpoint_public_access" {
  description = "eks_cluster_endpoint_public_access"
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "enable_cluster_creator_admin_permissions"
  type        = bool
  default     = true
}

variable "instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = ["r6a.2xlarge"]
}

variable "ami_type" {
  description = "Amazon Linux 2 AMI type"
  type        = string
  default     = "AL2_x86_64"
}

variable "efs_enabled" {
  description = "Flag to enable or disable EFS module"
  type        = bool
  default     = false
}

variable "authentication_mode" {
  description = "EKS authentication mode"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "capacity_type" {
  description = "capacity type"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_min_worker_count" {
  type        = number
  description = "The minimum workers up"
  default     = 1
}

variable "eks_max_worker_count" {
  type        = number
  description = "The maximum workers up"
  default     = 3
}

variable "desired_size" {
  type        = number
  description = "The desired number of workers"
  default     = 1
}

# Cluster Autoscaler
variable "deploy_autoscaler" {
  type        = bool
  description = "A boolean flag to control whether to install cluster autoscaler agent"
  default     = true
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
    project      = "k2v_cloud"
    owner        = "owner_name"
    customer     = "customer_name"
  }
}
