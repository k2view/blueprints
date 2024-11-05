variable "cloud_provider" {
  type        = string
  description = "The name of the cloud provider."
  default     = ""
}

variable "domain" {
  type        = string
  description = "The domain that will be used for ingress."
}

variable "internal_lb" {
  type        = bool
  description = "Internal IP for the LB"
  default     = false
}

# SSL cert
variable "keyPath" {
  type        = string
  description = "Path to the TLS key file."
  default     = ""
}

variable "certPath" {
  type        = string
  description = "Path to the TLS cert file."
  default     = ""
}

variable "keyString" {
  type        = string
  description = "The TLS key as a string."
  default     = ""
}

variable "certString" {
  type        = string
  description = "The TLS cert as a string."
  default     = ""
}

variable "keyb64String" {
  type        = string
  description = "The TLS key string in base 64."
  default     = ""
}

variable "certb64String" {
  type        = string
  description = "The TLS cert string in base 64."
  default     = ""
}

variable "delay_command" {
  type        = string
  description = "The command for delay, the command depends on the environment the Terraform is run on."
  default     = "sleep 60" #"sleep 60" for Linux, for Windows is "powershell -Command Start-Sleep -Seconds 60"
}
