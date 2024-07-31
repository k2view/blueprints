output "hz_zone_id" {
  value = aws_route53_zone.cluster_domain.id
}

output "cert_arn" {
  value = aws_acm_certificate.cert.arn
  description = "Certificate ARN"
}
