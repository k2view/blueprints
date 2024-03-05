terraform {
  required_version = ">=1.7"

  # backend "gcs" {
  #   bucket  = "[BUCKET_NAME]"
  #   prefix  = "terraform/state"
  # }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.10"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "Hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source  = "Hashicorp/kubernetes"
      version = "2.25.2"
    }
    null = {
    }
  }
}

provider "google" {
  project = var.project_id
}