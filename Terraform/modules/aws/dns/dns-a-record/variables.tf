variable "domain" {
	type        = string
	description = "Domain name for the Route 53 A record"
}

variable "nlb_dns_name" {
	type        = string
	description = "DNS name of the Network Load Balancer to alias"
}

variable "nlb_zone_id" {
	type        = string
	description = "Hosted zone ID of the Network Load Balancer (used for alias routing)"
}

variable "zone_id" {
	type        = string
	description = "Route 53 hosted zone ID where the records will be created"
}
