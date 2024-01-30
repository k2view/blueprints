terraform {
  required_providers {
    kubectl={
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
    helm={
      source = "Hashicorp/helm"
      version = "2.9.0"
    }
    kubernetes={
      source = "Hashicorp/kubernetes"
      version = "2.19.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
