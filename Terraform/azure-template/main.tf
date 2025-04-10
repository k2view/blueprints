module "resource-group" {
  source              = "../modules/azure/resource-group"
  count               = var.create_resource_group ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "private-network" {
  source = "../modules/azure/network/private-network"
  location = var.location
  prefix_name = var.prefix_name
  resource_group_name = module.resource-group[0].resource-group-name
}

module "acr" {
  source              = "../modules/azure/acr"
  acr_name            = "${var.prefix_name}SharedAcr"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "aks" {
  depends_on              = [module.private-network]
  source                  = "../modules/azure/aks"
  cluster_name            = var.cluster_name
  location                = var.location
  resource_group_name     = module.resource-group[0].resource-group-name
  private_cluster_enabled = var.private_cluster_enabled
  kubernetes_version      = "1.30"
  system_node_count       = var.system_node_count
  vm_sku                  = var.vm_sku
  max_size                = var.max_size
  min_size                = var.min_size
  subnet_id               = module.private-network.aks_subnet_id
  acr_id                  = module.acr.acr_id
  tags                    = var.tags
}

module "iam" {
  depends_on              = [module.resource-group]
  source = "../modules/azure/iam"
  cluster_name               = var.cluster_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  aks_principal_id           = module.aks.principal_id
  kubernetes_oidc_issuer_url = module.aks.cluster_oidc_url
  subnet_id                  = module.private-network.aks_subnet_id
}

# Ingress Controller
module "ingress-controller" {
  depends_on        = [module.aks]
  source            = "../modules/shared/ingress-controller"
  domain            = var.domain
  cloud_provider    = "azure"
  delay_command     = var.delay_command
  keyb64String      = var.ingress_controller_key_b64
  certb64String     = var.ingress_controller_cert_b64
  enable_private_lb = var.ingress_controller_enable_private_lb
}

# DNS
module "dns" {
  source                  = "../modules/azure/network/dns"
  resource_group_name     = var.resource_group_name
  domain                  = var.domain
  record_ip               = module.ingress-controller.nginx_lb_ip
  tags                    = var.tags
}

# K2view Agent
module "k2view-agent" {
  depends_on                        = [module.aks]
  source                            = "../modules/shared/k2view-agent"
  mailbox_id                        = var.mailbox_id
  mailbox_url                       = var.mailbox_url
  region                            = var.location
  cloud_provider                    = "azure"
  namespace                         = var.k2view_agent_namespace
  image                             = "docker.share.cloud.k2view.com/k2view/k2v-agent:latest"
  network_name                      = module.private-network.aks_network_name
  azure_subscription_id             = var.subscription_id
  azure_resource_group_name         = var.resource_group_name
  azure_oidc_issuer_url             = module.aks.cluster_oidc_url
  azure_workload_identity_id        = module.iam.deployer_identity_id
  azure_workload_identity_client_id = module.iam.deployer_identity_client_id
  azure_space_identity_client_id    = module.iam.space_identity_client_id
}

module "storage-account" {
  source      = "../modules/azure/storage-account"
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
}
