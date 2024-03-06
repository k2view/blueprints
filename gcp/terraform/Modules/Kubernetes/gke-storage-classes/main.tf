
resource "helm_release" "gcp-pd-storage-class" {
  name       = "gcp-pd-storage-class"
  chart      = "../../helm/charts/gcp-pd-storage-class"

  set {
    name = "region"
    value = "${var.region}"
  }

  timeout           = 600
  force_update      = true
  recreate_pods     = true
  disable_webhooks  = false
}
