resource "helm_release" "ingress-nginx" {
  name    = "ingress-nginx-controller"
  chart   = "../../helm/charts/ingress-nginx-k2v"

  set {
    name  = "provider"
    value = "azure"
  }

  set {
    name  = "ingressTest.domain"
    value = "${var.domain}"
  }

  set {
    name  = "errorPage.domain"
    value = "${var.domain}"
  }

  # ssl cert
  set {
    name  = "tlsSecret.enabled"
    value = true
  }

  set {
    name  = "tlsSecret.default_ssl_certificate"
    value = true
  }

  set {
    name  = "tlsSecret.keyPath"
    value = "${var.keyPath}"
  }

  set {
    name  = "tlsSecret.crtPath"
    value = "${var.crtPath}"
  }


  timeout           = 600
  force_update      = true
  recreate_pods     = true
  disable_webhooks  = false
}

resource "null_resource" "delay" {
  depends_on = [ helm_release.ingress-nginx ]

  provisioner "local-exec" {
    command = "sleep 60"  // Waits for 60 seconds
  }
}

data "kubernetes_service" "nginx_controller_svc" {
  depends_on = [null_resource.delay]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

