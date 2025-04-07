# Network
module "network-vpc" {
  source = "../modules/gcp/network/vpc"

  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name
}

# Deployer Service Accounts
module "iam-deployer-service-accounts" {
  source                 = "../modules/gcp/iam/deployer-service-accounts"
  cluster_name           = var.cluster_name
  project_id             = var.project_id
  k2view_agent_namespace = var.k2view_agent_namespace
  space_roles            = ["roles/storage.objectUser", "roles/cloudsql.client"]
}

# NAT Instance
module "nat-instance" {
  depends_on               = [module.network-vpc]
  count                    = var.create_nat_instance ? 1 : 0
  cluster_name             = var.cluster_name
  source                   = "../modules/gcp/nat-instance"
  subnet                   = "${var.cluster_name}-nat-subnet-01"
  dest_range               = var.nat_dest_range
  region                   = var.region
  vpc                      = module.network-vpc.network_name
  instance_type            = "e2-medium"
  nat_instance_ingress_gke = ["${var.secondary_cidr_pods}"]
  nat_instance_fw_ports    = var.nat_dest_ports
}

# GKE
module "gke" {
  source     = "../modules/gcp/gke"
  depends_on = [module.network-vpc]

  project_id         = var.project_id
  cluster_name       = var.cluster_name
  region             = var.region
  regional           = var.regional
  zones              = var.zones
  network_name       = module.network-vpc.network_name
  subnet_name        = "${var.cluster_name}-subnet-01"
  kubernetes_version = var.gke_kubernetes_version
  machine_type       = var.gke_worker_machine_type
  min_node           = var.gke_min_worker_count
  max_node           = var.gke_max_worker_count
  initial_node_count = var.gke_initial_worker_count
  disk_size_gb       = var.gke_worker_disk_size
  disk_type          = var.gke_worker_disk_type
}

# Ingress Controller
module "ingress-controller" {
  depends_on        = [module.gke]
  source            = "../modules/shared/ingress-controller"
  domain            = var.domain
  keyb64String      = var.ingress_controller_key_b64
  certb64String     = var.ingress_controller_cert_b64
  enable_private_lb = var.ingress_controller_enable_private_lb
}

# DNS
module "cloud-dns" {
  depends_on = [module.ingress-controller]
  source     = "../modules/gcp/network/dns"
  project_id = var.project_id
  name       = "${var.cluster_name}-dns"
  domain     = var.domain
  lb_ip      = module.ingress-controller.nginx_lb_ip
}

# K2view Agent
module "k2view-agent" {
  depends_on               = [module.gke]
  count                    = var.mailbox_id != "" ? 1 : 0
  source                   = "../modules/shared/k2view-agent"
  mailbox_id               = var.mailbox_id
  mailbox_url              = var.mailbox_url
  region                   = var.region
  project                  = var.project_id
  cloud_provider           = "GCP"
  namespace                = var.k2view_agent_namespace
  gcp_service_account_name = "${var.cluster_name}-deployer-sa"
  project_id               = var.project_id
  network_name             = "${var.cluster_name}-vpc"
}

# secret-store-csi deployment
module "secret-store-csi" {
  depends_on                    = [module.gke]
  count                         = var.deploy_secret_store_csi ? 1 : 0
  source                        = "../modules/shared/secret-store-csi"
}

# external-secret-operator deployment
module "external-secret-operator" {
  depends_on                    = [module.gke]
  count                         = var.deploy_secret_store_csi ? 1 : 0
  source                        = "../modules/shared/external-secret-operator"
}

# gcp secret-store-csi-provider  deployment
module "secret-store-csi-provider" {
  depends_on                    = [module.secret-store-csi]
  count                         = var.deploy_secret_store_csi ? 1 : 0
  source                        = "../modules/gcp/secrets-store-csi-driver-provider-gcp"
}
