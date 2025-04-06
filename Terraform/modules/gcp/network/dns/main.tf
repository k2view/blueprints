module "cloud-dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "5.3.0"
  domain = "${var.domain}."
  name = var.name
  project_id = var.project_id
  type = "public"
  dnssec_config = {
    state = "on"
  }
  recordsets = [
    {
      name    = "*"
      type    = "A"
      ttl     = 300
      records = [
        var.lb_ip,
      ]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = [
        var.lb_ip,
      ]
    },
  ]
}