variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
  default     = "k2view-dfaas"
}

variable "service_account_id" {
  description = "The service account ID."
  type        = string
  default     = "certguardian"
}

variable "service_account_display_name" {
  description = "The display name for the service account."
  type        = string
  default     = "certguardian"
}

variable "managed_zone" {
  description = "The DNS managed zone, if left empty the SA will have permessions over all DNS zones"
  type        = string
  default     = ""
}