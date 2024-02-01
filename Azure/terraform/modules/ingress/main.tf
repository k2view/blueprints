## Install nginx
resource "kubernetes_namespace" "ingress_nginx_ns" {
  metadata {
    name   =  var.nginx_namespace
    labels = {
      "app.kubernetes.io/name" =  var.nginx_namespace
    }
  }
}

resource "helm_release" "ingress_nginx" {
  depends_on = [ kubernetes_namespace.ingress_nginx_ns ]
  name       = "ingress-nginx"
  namespace  = var.nginx_namespace

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  timeout           = 600
  force_update      = true
  recreate_pods     = true
  disable_webhooks  = false
}

 resource "null_resource" "delay" {
   depends_on = [ helm_release.ingress_nginx ]

   provisioner "local-exec" {
     command = "sleep 60"  // Waits for 60 seconds
   }
 }

data "kubernetes_service" "nginx_controller_svc" {
  depends_on = [null_resource.delay]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = var.nginx_namespace
  }
}

## Test pod for nginx ingress
resource "kubernetes_namespace" "ingress_test_ns" {
  metadata {
    name   = "${var.nginx_namespace}-test"
    labels = {
      "app.kubernetes.io/name" = "${var.nginx_namespace}-test"
    }
  }

  depends_on = [ helm_release.ingress_nginx ]
}

resource "kubernetes_pod" "ingress_test_app" {
  metadata {
    name      = "${var.nginx_namespace}-test-app"
    namespace = "${var.nginx_namespace}-test"
    labels    = {
      app = "${var.nginx_namespace}-test"
    }
  }

  spec {
    container {
      name  = "${var.nginx_namespace}-test-app"
      image = "hashicorp/http-echo"
      args  = ["-text=SUCCESS"]
    }
  }

  depends_on = [ kubernetes_namespace.ingress_test_ns ]
}

resource "kubernetes_service" "ingress_test_service" {
  depends_on = [ kubernetes_pod.ingress_test_app ]
  metadata {
    name      = "${var.nginx_namespace}-test-service"
    namespace = "${var.nginx_namespace}-test"
  }

  spec {
    port {
      port = 5678
    }

    selector = {
      app = "${var.nginx_namespace}-test"
    }
  }
}

resource "kubernetes_ingress_v1" "ingress_test" {
  depends_on = [ kubernetes_service.ingress_test_service ]
  metadata {
    name      = "${var.nginx_namespace}-test"
    namespace = "${var.nginx_namespace}-test"

    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false",
      "kubernetes.io/ingress.class"              = "nginx"
    }
  }

  spec {
    tls {
      hosts = ["ingress-test.${var.domain}"]
    }

    rule {
      host = "ingress-test.${var.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "${var.nginx_namespace}-test-service"
              port {
                number = 5678
              }
            }
          }
        }
      }
    }
  }
}
