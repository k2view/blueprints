locals {
  helm_values = {
    provider = {
      name = "aws"
    }
    sources        = ["service", "ingress"]
    domainFilters  = [var.domain] # restrict to specific domain - important when using the policy sync
    policy         = "sync" # create, update, delete records
    # policy         = "upsert-only" # wond delete records at all - safest option 
    registry       = "txt"
    txtOwnerId     = var.cluster_name
    extraArgs      = ["--aws-zone-type=${var.zone_type}"]
    serviceAccount = {
      create = true
      name   = "external-dns"
      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn
      }
    }
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = var.namespace
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = var.chart_version

  values = [yamlencode(local.helm_values)]
}
