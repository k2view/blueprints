resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                    = var.cluster_name
  sku_tier                = "Standard"
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.cluster_name
  private_cluster_enabled = var.private_cluster_enabled
  kubernetes_version      = var.kubernetes_version

  default_node_pool {
    name                 = "default"
    node_count           = var.system_node_count
    vm_size              = var.vm_sku # "Standard_D8s_v3"
    type                 = "VirtualMachineScaleSets"
    zones                = [1,]
    max_count            = var.max_size
    min_count            = var.min_size
    auto_scaling_enabled = true
    vnet_subnet_id       = var.subnet_id
    upgrade_settings {
      max_surge                     = "10%"
      drain_timeout_in_minutes      = 0
      node_soak_duration_in_minutes = 0
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count  # Ignore changes to node_count as it will be managed by autoscaling
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet" # CNI
    outbound_type      = var.outbound_type
  }

  tags = var.tags
  
  // required for cert manager component 
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = var.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}