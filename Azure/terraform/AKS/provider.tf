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
    local = {
      source = "hashicorp/local"
      version = "2.5.1"
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
