terraform {
  required_version = ">= 0.13.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
    }
  }
}

provider "google" {
    project = var.project_id
    region  = var.region
}

provider "google-beta" {
    project = var.project_id
    region  = var.region
}