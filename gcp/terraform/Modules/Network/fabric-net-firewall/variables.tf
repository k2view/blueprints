variable "network" {
  description = "Name of the network this set of firewall rules applies to."
  type        = string
}

variable "project_id" {
  description = "Project id of the project that holds the network."
  type        = string
}

variable "internal_ranges_enabled" {
  description = "Create rules for intra-VPC ranges."
  type        = bool
  default     = false
}

variable "internal_ranges" {
  description = "IP CIDR ranges for intra-VPC rules."
  type        = list(string)
  default     = []
}

variable "internal_target_tags" {
  description = "List of target tags for intra-VPC rules."
  type        = list(string)
  default     = []
}

variable "internal_allow" {
  description = "Allow rules for internal ranges."
  default = [
    {
      protocol = "icmp"
    },
  ]
}

variable "admin_ranges_enabled" {
  description = "Enable admin ranges-based rules."
  type        = bool
  default     = false
}

variable "admin_ranges" {
  description = "IP CIDR ranges that have complete access to all subnets."
  type        = list(string)
  default     = []
}

variable "ssh_source_ranges" {
  description = "List of IP CIDR ranges for tag-based SSH rule, defaults to 0.0.0.0/0."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_target_tags" {
  description = "List of target tags for tag-based SSH rule, defaults to ssh."
  default     = ["ssh"]
}

variable "http_source_ranges" {
  description = "List of IP CIDR ranges for tag-based HTTP rule, defaults to 0.0.0.0/0."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_target_tags" {
  description = "List of target tags for tag-based HTTP rule, defaults to http-server."
  type        = list(string)
  default     = ["http-server"]
}

variable "https_source_ranges" {
  description = "List of IP CIDR ranges for tag-based HTTPS rule, defaults to 0.0.0.0/0."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_target_tags" {
  description = "List of target tags for tag-based HTTPS rule, defaults to https-server."
  type        = list(string)
  default     = ["https-server"]
}

variable "custom_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = {}
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes = map(string)
  }))
}
