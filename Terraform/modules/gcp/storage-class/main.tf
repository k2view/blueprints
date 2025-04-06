
resource "helm_release" "gcp-pd-storage-class" {
  name       = "gcp-pd-storage-class"
  chart      = "${path.module}/../../../helm/gcp/gcp-pd-storage-class"

  set {
    name = "region"
    value = "${var.region}"
  }

  set {
    name = "type"
    value = "${var.storage_class_type}"
  }

  timeout           = 600
  force_update      = true
  recreate_pods     = true
  disable_webhooks  = false
}
