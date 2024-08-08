variable "cloud_provider" {
  type        = string
  description = "The name of the cloud provider."
  default     = ""
}

variable "aws_cert_arn" {
  type        = string
  description = "The ARN of the certificate"
  default     = ""
}

variable "aws_vpc_cidr" {
  type        = string
  description = "The VPC CIDR range for aws"
  default     = ""
}

variable "domain" {
  type        = string
  description = "the domain will be used for ingress"
}

variable "enable_private_lb" {
  type        = bool
  description = "the domain will be used for ingress"
  default     = false
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
