resource "helm_release" "ingress-nginx" {
  name    = "ingress-nginx-controller"
  chart   = "../../helm/charts/ingress-nginx-k2v"

  set {
    name  = "provider"
    value = "azure"
  }

  set {
    name  = "domain"
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
    name  = "tlsSecret.certPath"
    value = "${var.certPath}"
  }

  set {
    name  = "tlsSecret.key"
    value = "${var.keyString}"
  }

  set {
    name  = "tlsSecret.cert"
    value = "${var.certString}"
  }

  set {
    name  = "tlsSecret.key_b64"
    value = "${var.keyb64String}"
  }

  set {
    name  = "tlsSecret.cert_b64"
    value = "${var.certb64String}"
  }

  timeout           = 600
  force_update      = true
  recreate_pods     = true
  disable_webhooks  = false
}

# The ingress controller will create LB, it can take some time to get it ready and get the IP
resource "null_resource" "delay" {
  depends_on = [ helm_release.ingress-nginx ]

  provisioner "local-exec" {
    command = "${var.delay_command}"  // Waits for 60 seconds
  }
}

# The IP of the service will be the IP of the LB 
data "kubernetes_service" "nginx_controller_svc" {
  depends_on = [null_resource.delay]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}
