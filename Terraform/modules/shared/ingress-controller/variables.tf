variable "cloud_provider" {
  type        = string
  description = "Cloud provider identifier (e.g. 'aws', 'gcp', 'azure'). Passed to the Helm chart as the 'provider' value."
  default     = ""
}

variable "domain" {
  type        = string
  description = "Base domain used for ingress routing (e.g. 'example.com')."
}

# SSL cert
variable "keyPath" {
  type        = string
  description = "Filesystem path to the TLS private key file. Mutually exclusive with keyString/keyb64String."
  default     = ""
}

variable "certPath" {
  type        = string
  description = "Filesystem path to the TLS certificate file. Mutually exclusive with certString/certb64String."
  default     = ""
}

variable "keyString" {
  type        = string
  description = "TLS private key as a plain-text string. Mutually exclusive with keyPath/keyb64String."
  default     = ""
}

variable "certString" {
  type        = string
  description = "TLS certificate as a plain-text string. Mutually exclusive with certPath/certb64String."
  default     = ""
}

variable "keyb64String" {
  type        = string
  description = "TLS private key encoded as a base64 string. Mutually exclusive with keyPath/keyString."
  default     = ""
}

variable "certb64String" {
  type        = string
  description = "TLS certificate encoded as a base64 string. Mutually exclusive with certPath/certString."
  default     = ""
}

variable "delay_command" {
  type        = string
  description = "Shell command used to wait for the ingress controller LoadBalancer to become ready. Use 'sleep 60' on Linux/macOS or 'powershell -Command Start-Sleep -Seconds 60' on Windows."
  default     = "sleep 60"
}

variable "enable_private_lb" {
  type        = bool
  description = "When true, the ingress controller LoadBalancer is created with a private (internal) IP instead of a public one."
  default     = false
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block passed to the Helm chart for AWS NLB source-range whitelisting (aws.vpc_cidr). AWS only."
  default     = ""
}

variable "aws_domain_cert_arn" {
  type        = string
  description = "ARN of the AWS ACM certificate to attach to the ingress controller LoadBalancer (aws.awsDomainCert). AWS only."
  default     = ""
}

variable "tls_enabled" {
  type        = bool
  description = "When true, the Helm chart creates a TLS secret (tlsSecret.enabled) and configures HTTPS on the ingress controller."
  default     = true
}

variable "default_ssl_certificate" {
  type        = bool
  description = "When true, the ingress controller uses the provisioned TLS secret as the default SSL certificate for all ingress resources."
  default     = true
}
