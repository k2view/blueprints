output "internal_ranges" {
  description = "Internal ranges."

  value = {
    enabled = var.internal_ranges_enabled
    ranges  = var.internal_ranges_enabled ? join(",", var.internal_ranges) : ""
  }
}

output "admin_ranges" {
  description = "Admin ranges data."

  value = {
    enabled = var.admin_ranges_enabled
    ranges  = var.admin_ranges_enabled ? join(",", var.admin_ranges) : ""
  }
}

output "custom_ingress_allow_rules" {
  description = "Custom ingress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.custom :
    rule.name if rule.direction == "INGRESS" && length(rule.allow) > 0
  ]
}

output "custom_ingress_deny_rules" {
  description = "Custom ingress rules with deny blocks."
  value = [
    for rule in google_compute_firewall.custom :
    rule.name if rule.direction == "INGRESS" && length(rule.deny) > 0
  ]
}

output "custom_egress_allow_rules" {
  description = "Custom egress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.custom :
    rule.name if rule.direction == "EGRESS" && length(rule.allow) > 0
  ]
}

output "custom_egress_deny_rules" {
  description = "Custom egress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.custom :
    rule.name if rule.direction == "EGRESS" && length(rule.deny) > 0
  ]
}
