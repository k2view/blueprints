variable "domain" {
  type        = string
  description = "the domain will be used for ingress"
}

variable "keyPath" {
  type        = string
  description = "Path to the TLS key file."
}

variable "crtPath" {
  type        = string
  description = "Path to the TLS cert file."
}

variable "cloud_provider" {
  type        = string
  description = "The name of the cloud provider."
  default     = ""
}

variable "delay_command" {
  type        = string
  description = "The command for delay (depend on the env)."
  default     = "sleep 60" #"sleep 60" for linux, for windows is "powershell -Command Start-Sleep -Seconds 60"
}
