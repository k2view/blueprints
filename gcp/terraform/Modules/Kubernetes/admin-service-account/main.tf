resource "kubernetes_service_account" "full_admin_user" {
  metadata {
    name      = var.name
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "full_admin_user" {
  metadata {
    name = var.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.name
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
}

resource "kubernetes_secret" "full_admin_user_secret" {
  metadata {
    name      = "full-admin-user-secret"
    namespace = "kube-system"

    annotations = {
      "kubernetes.io/service-account.name" = var.name
    }
  }

  type = "kubernetes.io/service-account-token"
}
