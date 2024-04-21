terraform {
  required_providers {
    kubectl={
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.97.0"
    }
    helm={
      source = "Hashicorp/helm"
      version = "2.13.0"
    }
    kubernetes={
      source = "Hashicorp/kubernetes"
      version = "2.27.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.5"
    }
    null={
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "azurerm" {
  features {}
}
