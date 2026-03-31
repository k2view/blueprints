# namespace name
variable "namespace" {
  type        = string
  description = "Kubernetes namespace for the k2view-agent Helm release."
  default     = "k2view-agent"
}

# K2view agent
variable "image" {
  type        = string
  description = "k2view agent Docker image URL."
  default     = "docker.share.cloud.k2view.com/k2view/k2v-agent:latest"
}

# Secrets used to config the agent
variable "mailbox_id" {
  type        = string
  description = "k2view cloud mailbox ID."
}

variable "mailbox_url" {
  type        = string
  description = "k2view cloud manager API URL."
  default     = "https://cloud.k2view.com/api/mailbox"
}

variable "region" {
  type        = string
  description = "Cloud region name passed to the agent."
  default     = ""
}

variable "network_name" {
  type        = string
  description = "VPC/network name passed to the agent. Used in GCP only."
  default     = ""
}

variable "subnet_name" {
  type        = string
  description = "Subnet name passed to the agent. Used in GCP only."
  default     = ""
}

## AWS secrets
variable "space_iam_arn" {
  type        = string
  description = "ARN of the AWS IAM role used by spaces (fabric). Used in AWS only."
  default     = ""
}

variable "subnets" {
  type        = string
  description = "Comma-separated subnet IDs passed to the agent. Used in AWS only."
  default     = ""
}

## GCP secrets
variable "project" {
  type        = string
  description = "GCP project name passed to the agent. Used in GCP only."
  default     = ""
}

## AZURE secrets
variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID passed to the agent. Used in Azure only."
  default     = ""
}

variable "azure_resource_group_name" {
  type        = string
  description = "Azure resource group name passed to the agent. Used in Azure only."
  default     = ""
}

variable "azure_oidc_issuer_url" {
  type        = string
  description = "Azure AKS OIDC issuer URL for workload identity federation. Used in Azure only."
  default     = ""
}

# serviceAccount (for cloud-deployer)
variable "cloud_provider" {
  type        = string
  description = "Cloud provider identifier (e.g. 'aws', 'gcp', 'azure'). Sets the CLOUD secret and the serviceAccount provider."
  default     = ""
}

## AWS IAM role
variable "deployer_iam_arn" {
  type        = string
  description = "ARN of the AWS IAM role used by the deployer service account to create resources. Used in AWS only."
  default     = ""
}

## GCP service account
variable "gcp_service_account_name" {
  type        = string
  description = "GCP service account name annotated on the deployer Kubernetes service account. Used in GCP only."
  default     = ""
}

variable "project_id" {
  type        = string
  description = "GCP project ID annotated on the deployer Kubernetes service account. Used in GCP only."
  default     = ""
}

## Azure workload identity
variable "azure_workload_identity_id" {
  type        = string
  description = "Azure workload identity object/principal ID. Used in Azure only. Currently declared but not wired to the Helm chart."
  default     = ""
}

variable "azure_workload_identity_client_id" {
  type        = string
  description = "Azure workload identity client ID for the deployer service account (serviceAccount.azure_workload_identity_client_id). Used in Azure only."
  default     = ""
}

variable "azure_space_identity_client_id" {
  type        = string
  description = "Azure managed identity client ID for space workloads (secrets.AZURE_SPACE_IDENTITY_CLIENT_ID). Used in Azure only."
  default     = ""
}

# Helm user values
variable "helm_user_values_json" {
  type        = string
  description = "JSON string of user-defined Helm values to override space deployment defaults."
  default     = ""
}
