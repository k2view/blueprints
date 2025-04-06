variable "region" {
	type        = string
	description = "The GCP region"
	default     = "europe-west3"
}

variable "storage_class_type" {
	type        = string
	description = "The type of the storage class"
	default     = "pd-balanced"
}
