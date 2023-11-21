resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"

  namespace        = "external-secrets"
  create_namespace = true
}

resource "helm_release" "k2view" {
  name    = "k2view"
  chart   = "./Helm/k2-defaults"
  timeout = 100

  # Global values
  set {
    name  = "global.clusterName"
    value = var.cluster_name
  }

  depends_on = [
    module.eks,
    helm_release.external_secrets
  ]
}

resource "helm_release" "nginx-ingress" {
  name    = "ingress"
  chart   = "./Helm/charts/nginx-ingress"
  timeout = 100

  set {
    name = "vpcCIDR"
    value = local.vpc_cidr
  }
  set {
    name  = "awsDomainCert"
    value = module.subdomain-hz[0].cert_arn
  }
  set {
    name  = "domainName"
    value = var.domain
  }

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "sc-fabric" {
  name    = "sc-fabric"
  chart   = "./Helm/charts/sc-efs"
  timeout = 100

  set {
    name  = "fileSystemId"
    value = module.efs.efs_id
  }
  set {
    name  = "sc_name"
    value = "efs-sc"
  }
  set {
    name  = "uid"
    value = "1000"
  }
  set {
    name  = "gidRangeStart"
    value = "1000"
  }
  set {
    name  = "gidRangeEnd"
    value = "2000"
  }

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "sc-cassandra" {
  name    = "sc-cassandra"
  chart   = "./Helm/charts/sc-efs"
  timeout = 100

  set {
    name  = "fileSystemId"
    value = module.efs.efs_id
  }
  set {
    name  = "sc_name"
    value = "efs-cassandra"
  }
  set {
    name  = "uid"
    value = "0"
  }
  set {
    name  = "gidRangeStart"
    value = "1"
  }
  set {
    name  = "gidRangeEnd"
    value = "1000"
  }

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "sc-pg" {
  name    = "sc-pg"
  chart   = "./Helm/charts/sc-efs"
  timeout = 100

  set {
    name  = "fileSystemId"
    value = module.efs.efs_id
  }
  set {
    name  = "sc_name"
    value = "efs-pg"
  }
  set {
    name  = "uid"
    value = "999"
  }
  set {
    name  = "gidRangeStart"
    value = "999"
  }
  set {
    name  = "gidRangeEnd"
    value = "1000"
  }

  depends_on = [
    module.eks
  ]
}
