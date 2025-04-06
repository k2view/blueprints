resource "helm_release" "csi-secrets-store" {
  name  = "csi-secrets-store"
  namespace = "kube-system"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart = "secrets-store-csi-driver"

  set {
    name  = "enableSecretRotation"
    value = "false"
  }
}