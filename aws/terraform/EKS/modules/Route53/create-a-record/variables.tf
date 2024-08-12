variable "domain" {
	type        = string
	description = "Subdomain for rout53."
}

variable "nlb_dns_name" {
	type        = string
	description = "NLB dns name."
}

variable "nlb_zone_id" {
	type        = string
	description = "Hosted zone id to create a record on"
}

variable "zone_id" {
	type        = string
	description = "Hosted zone id to create a record on"
}
