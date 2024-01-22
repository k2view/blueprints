output "admin_user_token" {
  value     = kubernetes_secret.full_admin_user_secret.data
  sensitive = true
}
