terraform {
  required_version = ">= 0.13.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "<5.0,>= 2.12"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-network:fabric-net-firewall/v5.0.0"
  }
}
