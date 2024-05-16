resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "AKS_private_network" {
  source                        = "../modules/private_network"
  resource_group_name           = var.create_resource_group ? azurerm_resource_group.rg[0].name : var.resource_group_name
  location                      = var.location
  prefix_name                   = var.cluster_name
  tags                          = var.tags
  subnet_address_prefixes       = var.subnet_address_prefixes
  create_network                = var.create_network
  subnet_id                     = var.subnet_id
  virtual_network_address_space = var.virtual_network_address_space
  create_nat_gateway            = var.create_nat_gateway
  create_route_table            = var.create_route_table
  route_table_next_hop_ip       = var.route_table_next_hop_ip
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  depends_on              = [ module.AKS_private_network ]
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
    enable_auto_scaling  = true
    vnet_subnet_id       = var.subnet_id != "" ? var.subnet_id : module.AKS_private_network.aks_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet" # CNI
    outbound_type      = var.outbound_type
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.subnet_id != "" ? var.subnet_id : module.AKS_private_network.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
}

resource "random_string" "acr_suffix" {
  count   = var.acr_name == "" ? 1 : 0
  length  = 6
  special = false
  numeric  = true
}

module "create_acr" {
  count               = var.create_acr ? 1 : 0
  depends_on          = [ azurerm_kubernetes_cluster.aks_cluster ]
  source              = "../modules/acr"
  acr_name            = var.acr_name != "" ? var.acr_name : "${random_string.acr_suffix[0].result}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  principal_id        = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity.0.object_id
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "grafana_agent" {
  count            = var.deploy_grafana_agent && !var.private_cluster_enabled ? 1 : 0
  depends_on       = [ azurerm_kubernetes_cluster.aks_cluster ]
  name             = "grafana-agent"
  chart            = "../../helm/charts/grafana-agent/k8s-monitoring"

  namespace        = "grafana-agent"
  create_namespace = true
  values = [
    "${file("grafana-agent-values.yaml")}"
  ]
}

module "AKS_ingress" {
  count                   = var.deploy_ingress && !var.private_cluster_enabled ? 1 : 0
  depends_on              = [ azurerm_kubernetes_cluster.aks_cluster ]
  source                  = "../modules/ingress"
  domain                  = var.domain
  cloud_provider          = "azure"
  delay_command           = var.delay_command
  internal_lb             = var.internal_lb
  keyb64String            = base64encode(file(var.keyPath))
  certb64String           = base64encode(file(var.certPath))
}

module "AKS_k2v_agent" {
  count                   = var.mailbox_id != "" && !var.private_cluster_enabled ? 1 : 0
  depends_on              = [ azurerm_kubernetes_cluster.aks_cluster ]
  source                  = "../modules/k2v_agent"
  mailbox_id              = var.mailbox_id
  mailbox_url             = var.mailbox_url
  region                  = var.location
  cloud_provider          = "azure"
}

module "DNS_zone" {
  count                   = var.create_dns ? 1 : 0
  source                  = "../modules/dns_zone"
  resource_group_name     = var.resource_group_name
  domain                  = var.domain
  record_ip               = var.lb_ip != "" ? var.lb_ip : module.AKS_ingress[0].nginx_lb_ip
  tags                    = var.tags
}
