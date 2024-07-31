locals {
  subdomain     = regex("^[^.]*", var.domain)
  parent_domain = replace(var.domain, "${local.subdomain}.", "")
}

### Create domain record ##
resource "aws_route53_zone" "cluster_domain" {
  name = "${var.domain}"

  tags = {
    Name        = "${var.cluster_name}_domain"
    Env         = var.env
    Owner       = var.owner
    Project     = var.project
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.domain}"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain}"
  ]

  tags = {
    Name        = "${var.cluster_name}_domain"
    Env         = var.env
    Owner       = var.owner
    Project     = var.project
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cret_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.cluster_domain.zone_id
}

## adding NS records of just created Hosted Zone to parent Domain Hosted Zone
data "aws_route53_zone" "parent_hosted_zone" {
  count = var.update_parent_hosted_zone ? 1 : 0
  name  = local.parent_domain
}

resource "aws_route53_record" "parent_hz_ns_record" {
  count   = var.update_parent_hosted_zone ? 1 : 0
  zone_id = data.aws_route53_zone.parent_hosted_zone[count.index]
  name    = "${var.domain}"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.cluster_domain.name_servers
}
