### NETWORK ###
# Managed VPC module creating VPC, subnet and secondary ranges for pods and services
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "9.1.0"

  project_id   = var.project_id
  network_name = var.network_name != "" ? var.network_name : "${var.cluster_name}-vpc"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = "${var.cluster_name}-subnet-01"
      subnet_ip     = var.subnet_cidr
      subnet_region = var.region
    },
    {
      subnet_name   = "${var.cluster_name}-nat-subnet-01"
      subnet_ip     = var.nat_subnet_cidr
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    "${var.cluster_name}-subnet-01" = [
      {
        range_name    = "${var.cluster_name}-subnet-01-pods"
        ip_cidr_range = var.secondary_cidr_pods
      },
      {
        range_name    = "${var.cluster_name}-subnet-01-services"
        ip_cidr_range = var.secondary_cidr_services
      }
    ]
  }
}

# Create an IP address range for private services connection
# Used by AlloyDB
resource "google_compute_global_address" "private_services_ip" {
  depends_on    = [module.vpc]
  name          = "${var.cluster_name}-private-services-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.network_id
}

# Create a private connection
resource "google_service_networking_connection" "private_services_connection" {
  network                 = module.vpc.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_services_ip.name]
}

# Create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.cluster_name}-nat-router"
  network = module.vpc.network_name
  region  = var.region
}

# Create Nat Gateway with module
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "5.1.0"
  project_id = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
  name       = "${var.cluster_name}-nat-config"
}

# Deploy Service Accounts
module "service-accounts" {
  source                 = "../Modules/cloud-private-site/service-accounts"
  cluster_name           = var.cluster_name
  project_id             = var.project_id
  k2view_agent_namespace = var.k2view_agent_namespace
  space_roles            = ["roles/storage.objectUser", "roles/cloudsql.client"]
}

# Deploy NAT instance which routes traffic from all pods via a single IP address
module "nat_instance" {
  depends_on               = [module.vpc]
  count                    = var.create_nat_instnace ? 1 : 0
  cluster_name             = var.cluster_name
  source                   = "../Modules/k2_nat_instance"
  subnet                   = "${var.cluster_name}-nat-subnet-01"
  dest_range               = var.nat_dest_range
  region                   = var.region
  vpc                      = module.vpc.network_name
  instance_type            = "e2-medium"
  nat_instance_ingress_gke = ["${var.secondary_cidr_pods}"]
  nat_instance_fw_ports    = var.nat_dest_ports
}

### GKE ###
# Service account for GKE worker nodes
module "GKE_service_account" {
  source                       = "../Modules/gke_service_account"
  project_id                   = var.project_id
  service_account_id           = "${var.cluster_name}-gke-sa"
  service_account_display_name = "${var.cluster_name}-gke-sa"
}

# Create list of strings containing zones for GKE
locals {
  region_zones = [for zone in var.zones : "${var.region}-${zone}"]
}

module "gke" {
  depends_on = [module.vpc]
  source     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version    = "31.0.0"

  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  regional                   = var.regional
  zones                      = local.region_zones
  network                    = module.vpc.network_name
  subnetwork                 = "${var.cluster_name}-subnet-01"
  ip_range_pods              = "${var.cluster_name}-subnet-01-pods"
  ip_range_services          = "${var.cluster_name}-subnet-01-services"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  enable_private_endpoint    = false
  enable_private_nodes       = true
  remove_default_node_pool   = true
  deletion_protection        = false
  kubernetes_version         = var.kubernetes_version

  node_pools = [
    {
      name                      = "${var.cluster_name}-np"
      machine_type              = var.machine_type
      node_locations            = var.regional ? join(",", local.region_zones) : "${var.region}-${var.zones[0]}"
      min_count                 = var.min_node
      max_count                 = var.max_node
      local_ssd_count           = 0
      spot                      = false
      local_ssd_ephemeral_count = 0
      disk_size_gb              = var.disk_size_gb
      disk_type                 = var.disk_type
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      service_account           = module.GKE_service_account.service_account_email
      preemptible               = false
      initial_node_count        = var.initial_node_count
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "${var.cluster_name}-np"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "${var.cluster_name}-np"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all                      = []
    default-node-pool        = ["${var.cluster_name}-np", ]
    "${var.cluster_name}-np" = ["use-nat"]
  }
}

# Deploy ingress controller
module "GKE_ingress" {
  depends_on        = [module.gke]
  source            = "../Modules/ingress"
  domain            = var.domain
  keyb64String      = base64encode(file(var.keyPath))
  certb64String     = base64encode(file(var.certPath))
  whitelist_enabled = var.whitelist_enabled
  whitelist_ips     = var.whitelist_ips
}

# Deploy K2view agent
module "k2v_agent" {
  depends_on               = [module.gke]
  count                    = var.mailbox_id != "" ? 1 : 0
  source                   = "../Modules/k2v_agent"
  mailbox_id               = var.mailbox_id
  mailbox_url              = var.mailbox_url
  region                   = var.region
  cloud_provider           = "GCP"
  namespace                = var.k2view_agent_namespace
  gcp_service_account_name = "${var.cluster_name}-deployer-sa"
  project_id               = var.project_id
  network_name             = module.vpc.network_name
}

### Grafana Agent ###
module "grafana_agent" {
  depends_on                                     = [module.gke]
  count                                          = var.deploy_grafana_agent ? 1 : 0
  source                                         = "../Modules/grafana-agent"
  cluster_name                                   = var.cluster_name
  externalservices_prometheus_basicauth_password = var.grafana_token
  externalservices_loki_basicauth_password       = var.grafana_token
  externalservices_tempo_basicauth_password      = var.grafana_token
}

# Deploy storage classes
module "GKE_storage_classes" {
  depends_on = [module.gke]
  source     = "../Modules/Kubernetes/gke-storage-classes"
  region     = var.region
}

data "kubernetes_service" "nginx_lb" {
  depends_on = [module.GKE_ingress]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

module "cloud_dns" {
  source       = "../Modules/Network/cloud-dns"
  project_id   = var.project_id
  cluster_name = var.cluster_name
  domain       = var.domain
  lb_ip        = data.kubernetes_service.nginx_lb.status.0.load_balancer.0.ingress.0.ip
}
