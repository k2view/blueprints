## Create Cloud DNS
resource "google_dns_managed_zone" "cluster_dns" {
  name        = "${var.cluster_name}-dns"
  dns_name    = "${var.domain}."
  description = "DNS for ${var.cluster_name} cluster"
  visibility  = "public"
  dnssec_config {
    state = "on"
  }
}

## Create record Cloud DNS to LB
resource "google_dns_record_set" "cluster_dns_record" {
  #count = var.lb_ip != "" ? 1 : 0
  name  = "*.${var.domain}."
  type  = "A"
  ttl   = 300
  
  managed_zone = google_dns_managed_zone.cluster_dns.name
  rrdatas = [var.lb_ip]
}
