resource "helm_release" "ingress-nginx" {
  name    = "ingress-nginx-controller"
  chart   = "helm/aws-nginx-ingress-controller"

  set {
    name  = "aws_domain_cert"
    value = "${var.aws_cert_arn}"
  }

  set {
    name  = "vpc_cidr"
    value = "${var.aws_vpc_cidr}"
  }

  set {
    name  = "domain_name"
    value = "${var.domain}"
  }

  set {
    name  = "private_lb"
    value = var.enable_private_lb
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
