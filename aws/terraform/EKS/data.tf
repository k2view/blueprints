data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

data "kubernetes_service" "nginx-ingress" {
  metadata {
    namespace = "ingress-nginx"
    name = "ingress-nginx-controller"
  }

  depends_on = [resource.helm_release.k2view]
}

data "aws_lb" "nginx-nlb" {
  name = regex("^(?P<name>.+)-.+\\.elb\\..+\\.amazonaws\\.com", data.kubernetes_service.nginx-ingress.status.0.load_balancer.0.ingress.0.hostname)["name"]
  depends_on = [data.kubernetes_service.nginx-ingress]
}