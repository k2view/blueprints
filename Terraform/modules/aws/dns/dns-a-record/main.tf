resource "aws_route53_record" "record_to_nlb" {
  zone_id = "${var.zone_id}"
  name    = "${var.domain}"
  type    = "A"

  alias {
    name                   = var.nlb_dns_name
    zone_id                = var.nlb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "record_to_nlb_wildCard" {
  zone_id = "${var.zone_id}"
  name    = "*.${var.domain}"
  type    = "A"

  alias {
    name                   = var.nlb_dns_name
    zone_id                = var.nlb_zone_id
    evaluate_target_health = true
  }
}