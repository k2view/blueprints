# namespace name
variable "namespace" {
  type        = string
  description = "k2view agent namespace name."
  default     = "k2view-agent"
}

# K2view agent 
variable "image" {
  type        = string
  description = "k2view agent image url."
  default     = "docker.share.cloud.k2view.com/k2view/k2v-agent:latest"
}

# Secrets used to config the agent
variable "mailbox_id" {
  type        = string
  description = "k2view cloud mailbox ID."
}

variable "mailbox_url" {
  type        = string
  description = "k2view cloud mailbox URL."
  default     = "https://cloud.k2view.com/api/mailbox"
}

variable "region" {
  type        = string
  description = "The name of the cloud region."
  default     = ""
}

variable "network_name" {
  type        = string
  description = "The name of the VPC."
  default     = ""
}

variable "subnet_name" {
  type        = string
  description = "The name of the PG subnet."
  default     = ""
}

## AWS secrets
variable "space_iam_arn" {
  type        = string
  description = "IAM of AWS role for spaces."
  default     = ""
}

variable "subnets" {
  type        = string
  description = "Subnets names separated by comma - AWS only"
  default     = ""
}

## GCP secrets
variable "project" {
  type        = string
  description = "Name of GCP project."
  default     = ""
}

## AZURE secrets
variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  default     = ""
}

variable "azure_resource_group_name" {
  type        = string
  description = "Azure Resource Group Name"
  default     = ""
}

variable "azure_oidc_issuer_url" {
  type        = string
  description = "Azure OIDC Issuer URL"
  default     = ""
}

# serviceAccount
variable "cloud_provider" {
  type        = string
  description = "The name of the cloud provider."
  default     = ""
}

variable "deployer_iam_arn" {
  type        = string
  description = "IAM of AWS role for deployer."
  default     = ""
}

variable "gcp_service_account_name" {
  type        = string
  description = "GCP service account name."
  default     = ""
}

variable "project_id" {
  type        = string
  description = "Name of GCP project."
  default     = ""
}



variable "azure_workload_identity_id" {
  type        = string
  description = "Azure workload identity client id"
  default     = ""
}

variable "azure_workload_identity_client_id" {
  type        = string
  description = "Azure workload identity client id"
  default     = ""
}

variable "azure_space_identity_client_id" {
  type        = string
  description = "Azure space identity client id"
  default     = ""
}