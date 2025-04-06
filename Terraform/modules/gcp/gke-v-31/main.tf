# GKE Service Account
module "gke-service-account" {
  source                       = "../iam/gke-service-account"
  project_id                   = var.project_id
  service_account_id           = "${var.cluster_name}-gke-sa"
  service_account_display_name = "${var.cluster_name}-gke-sa"
}

# Create list of strings containing zones for GKE
locals {
  region_zones = [for zone in var.zones : "${var.region}-${zone}"]
}

# GKE
module "gke" {
  depends_on = [module.gke-service-account]
  source     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version    = "31.1.0"

  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  regional                   = var.regional
  zones                      = local.region_zones
  network                    = var.network_name
  subnetwork                 = var.subnet_name
  ip_range_pods              = "${var.subnet_name}-pods"
  ip_range_services          = "${var.subnet_name}-services"
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
      service_account           = module.gke-service-account.service_account_email
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

# Storage Class
module "storage-class" {
  depends_on = [module.gke]
  source     = "../storage-class"
  region     = var.region
  storage_class_type = var.storage_class_type
}