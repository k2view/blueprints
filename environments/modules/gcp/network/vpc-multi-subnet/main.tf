# Managed VPC module creating VPC, subnet and secondary ranges for pods and services
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "10.0.0"

  project_id   = var.project_id
  network_name = "${var.network_name}-vpc"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = "${var.network_name}-dev-subnet-01"
      subnet_ip     = var.dev_subnet_cidr
      subnet_region = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name   = "${var.network_name}-staging-subnet-01"
      subnet_ip     = var.staging_subnet_cidr
      subnet_region = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name   = "${var.network_name}-prod-subnet-01"
      subnet_ip     = var.prod_subnet_cidr
      subnet_region = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name   = "${var.network_name}-nat-subnet-01"
      subnet_ip     = var.nat_subnet_cidr
      subnet_region = var.region
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    "${var.network_name}-dev-subnet-01" = [
      {
        range_name    = "${var.network_name}-dev-subnet-01-pods"
        ip_cidr_range = var.dev_secondary_cidr_pods
      },
      {
        range_name    = "${var.network_name}-dev-subnet-01-services"
        ip_cidr_range = var.dev_secondary_cidr_services
      },
    ]
    "${var.network_name}-staging-subnet-01" = [
      {
        range_name    = "${var.network_name}-staging-subnet-01-pods"
        ip_cidr_range = var.staging_secondary_cidr_pods
      },
      {
        range_name    = "${var.network_name}-staging-subnet-01-services"
        ip_cidr_range = var.staging_secondary_cidr_services
      },
    ]
    "${var.network_name}-prod-subnet-01" = [
      {
        range_name    = "${var.network_name}-prod-subnet-01-pods"
        ip_cidr_range = var.prod_secondary_cidr_pods
      },
      {
        range_name    = "${var.network_name}-prod-subnet-01-services"
        ip_cidr_range = var.prod_secondary_cidr_services
      },
    ]
  }
}

# Create an IP address range for private services connection
resource "google_compute_global_address" "private_services_ip" {
  depends_on    = [module.vpc]
  name          = "${var.network_name}-private-services-ip"
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

# create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.network_name}-nat-router"
  network = module.vpc.network_name
  region  = var.region
}


## Create Nat Gateway with module

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "5.3.0"
  project_id = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
  name       = "${var.network_name}-nat-config"
}

# # Firewall
# resource "google_compute_firewall" "nat_instance_firewall_ssh" {
#   depends_on = [module.vpc]
#   name       = "${var.cluster_name}-ssh-to-nat"
#   network    = module.vpc.network_name

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   source_ranges = ["${var.gcp_console_access_cidr}"]
#   target_tags   = ["nat"]
# }