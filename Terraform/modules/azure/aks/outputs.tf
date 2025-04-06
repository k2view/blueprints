output "principal_id" {
    # value = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
    value = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
    description = "Principal ID of the K8S cluster"
}

output "host" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    description = "K8S Host for Providers"
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
    description = "K8S Client Certificate for Providers"
}

output "client_key" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key
    description = "K8S Client Key for Providers"
}

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate
    description = "K8S Client CA Certificate for Providers"
}

output "cluster_oidc_url" {
    value = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
    description = "K8S OIDC URL"
}