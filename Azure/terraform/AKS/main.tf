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
  virtual_network_address_space = var.virtual_network_address_space
  subnet_address_prefixes       = var.subnet_address_prefixes
  tags                          = var.tags
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  depends_on              = [ module.AKS_private_network ]
  name                    = var.cluster_name
  sku_tier                = "Paid" #Standard
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.cluster_name
  private_cluster_enabled = var.private_cluster_enabled 

  default_node_pool {
    name                = "default"
    node_count          = var.system_node_count
    vm_size             = var.vm_sku # "Standard_D8s_v3"
    type                = "VirtualMachineScaleSets"
    availability_zones  = [1,]
    max_count           = var.max_size
    min_count           = var.min_size
    enable_auto_scaling = true
    vnet_subnet_id      = module.AKS_private_network.aks_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet" # CNI
  }

  tags = var.tags
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

module "AKS_ingress" {
  depends_on              = [ azurerm_kubernetes_cluster.aks_cluster ]
  source                  = "../modules/ingress"
  domain                  = var.domain
  keyPath                 = var.keyPath
  crtPath                 = var.crtPath
  cloud_provider          = "azure"
  delay_command           = var.delay_command
}

module "AKS_k2v_agent" {
  depends_on              = [ azurerm_kubernetes_cluster.aks_cluster ]
  count                   = var.mailbox_id != "" ? 1 : 0
  source                  = "../modules/k2v_agent"
  mailbox_id              = var.mailbox_id
  mailbox_url             = var.mailbox_url
  region                  = var.location
  cloud                   = "azure"
  cloud_provider          = "azure"
}

module "DNS_zone" {
  count                   = var.create_dns ? 1 : 0
  depends_on              = [ module.AKS_ingress ]
  source                  = "../modules/dns_zone"
  resource_group_name     = var.resource_group_name
  domain                  = var.domain
  record_ip               = module.AKS_ingress.nginx_lb_ip
  tags                    = var.tags
}
