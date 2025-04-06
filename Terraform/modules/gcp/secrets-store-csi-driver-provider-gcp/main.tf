
resource "helm_release" "secrets-store-csi-driver-provider-gcp" {
  name       = "secrets-store-csi-driver-provider-gcp"
  chart      = "../../../helm/gcp/secrets-store-csi-driver-provider-gcp"

}
