output "ingress_test_url" {
  value = "http://ingress-test.${var.domain}"
}

output "nginx_lb_ip" {
  value = data.kubernetes_service.nginx_controller_svc.status.0.load_balancer.0.ingress.0.ip
}
