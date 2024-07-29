terraform {
  required_version = ">=1.7"

  # backend "gcs" {
  #   bucket  = "[BUCKET_NAME]"
  #   prefix  = "terraform/state"
  # }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.31.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "Hashicorp/helm"
      version = "2.13.2"
    }
    kubernetes = {
      source  = "Hashicorp/kubernetes"
      version = "2.30.0"
    }
    null = {
    }
  }
}

provider "google" {
  project = var.project_id
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}