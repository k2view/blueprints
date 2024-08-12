output "hz_zone_id" {
  value       = aws_route53_zone.cluster_domain.id
  description = "Route 53 hosted zone ID."
}

output "cert_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "ACM certificate ARN."
}
