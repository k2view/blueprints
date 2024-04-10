### NETWORK ###

# Managed VPC module creating VPC, subnet and secondary ranges for pods and services
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "9.0"

  project_id   = var.project_id
  network_name = var.network_name != "" ? var.network_name : "${var.cluster_name}-vpc"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = "${var.cluster_name}-subnet-01"
      subnet_ip     = var.subnet_cidr
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

## Create Nat Gateway with module

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "5.0.0"
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
}

### GKE ###
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

# Create list of strings containing zones for GKE
locals {
  region_zones = [for zone in var.zones : "${var.region}-${zone}"]
}

module "gke" {
  depends_on = [module.vpc]
  source     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version    = "29.0.0"

  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  regional                   = var.regional
  zones                      = local.region_zones
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names[0]
  ip_range_pods              = "${module.vpc.subnets_names[0]}-pods"
  ip_range_services          = "${module.vpc.subnets_names[0]}-services"
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
      service_account           = ""
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
    all               = []
    default-node-pool = ["${var.cluster_name}-np", ]
  }
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

# Deploy ingress controller
module "GKE_ingress" {
  depends_on              = [module.gke]
  source                  = "../Modules/ingress"
  domain                  = var.domain
  keyb64String            = base64encode(file(var.keyPath))
  certb64String           = base64encode(file(var.certPath))
}

# Deploy K2view agent
module "k2v_agent" {
  depends_on              = [module.gke]
  count                   = var.mailbox_id != "" ? 1 : 0
  source                  = "../Modules/k2v_agent"
  mailbox_id              = var.mailbox_id
  mailbox_url             = var.mailbox_url
  region                  = var.region
  cloud_provider          = "gcp"
}

# Deploy Grafana agent
resource "helm_release" "grafana_agent" {
  count = var.deploy_grafana_agent ? 1 : 0
  name  = "grafana-agent"
  chart = "../../helm/charts/grafana-agent/k8s-monitoring"

  depends_on       = [module.gke]
  namespace        = "grafana-agent"
  create_namespace = true
  values = [
    "${file("grafana-agent-values.yaml")}"
  ]

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
