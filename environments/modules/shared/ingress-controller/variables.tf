variable "cloud_provider" {
  type        = string
  description = "The name of the cloud provider."
  default     = ""
}

variable "domain" {
  type        = string
  description = "the domain will be used for ingress"
}

# SSL cert
variable "keyPath" {
  type        = string
  description = "Path to the TLS key file."
  default = ""
}

variable "certPath" {
  type        = string
  description = "Path to the TLS cert file."
  default = ""
}

variable "keyString" {
  type        = string
  description = "The TLS key as a string."
  default = ""
}

variable "certString" {
  type        = string
  description = "The TLS cert as a string."
  default = ""
}

variable "keyb64String" {
  type        = string
  description = "The TLS key string in base 64."
  default = ""
}

variable "certb64String" {
  type        = string
  description = "The TLS cert string in base 64."
  default = ""
}

variable "delay_command" {
  type        = string
  description = "The command for delay, the cammand depend on the env the terraform runed on."
  default     = "sleep 60" #"sleep 60" for linux, for windows is "powershell -Command Start-Sleep -Seconds 60"
}

variable "enable_private_lb" {
  type        = bool
  description = "Flag to enable or disable private load balancer IP"
  default     = false
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR range of the network"
  default     = ""  
}

variable "aws_domain_cert_arn" {
  type        = string
  description = "The ARN of the AWS domain certificate."
  default     = ""
}

variable "tls_enabled" {
  type        = bool
  description = "Flag to enable or disable TLS"
  default     = true
}

variable "default_ssl_certificate" {
  type        = bool
  description = "Flag to enable or disable default SSL certificate"
  default     = true
}