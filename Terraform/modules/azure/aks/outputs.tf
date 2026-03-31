output "principal_id" {
    value = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
    description = "Principal ID of the cluster's system-assigned managed identity."
}

output "host" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    description = "AKS API server endpoint. Used to configure the Kubernetes and Helm providers."
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
    description = "Base64-encoded client certificate for authenticating to the AKS API server."
}

output "client_key" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key
    description = "Base64-encoded client private key for authenticating to the AKS API server."
}

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate
    description = "Base64-encoded cluster CA certificate."
}

output "cluster_oidc_url" {
    value = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
    description = "OIDC issuer URL of the cluster. Required for workload identity federation."
}
