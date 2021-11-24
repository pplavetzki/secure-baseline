terraform {
  required_version = ">= 0.13"

  required_providers {
    github = {
     source = "integrations/github"
     version = ">= 4.5.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.8.0"
    }
    tls = {
     source  = "hashicorp/tls"
     version = "3.1.0"
    }
  }
  backend "azurerm" {
    # resource_group_name  = ""   # Partial configuration, provided during "terraform init"
    # storage_account_name = ""   # Partial configuration, provided during "terraform init"
    # container_name       = ""   # Partial configuration, provided during "terraform init"
    key                  = "gitops"
  }
}

provider "flux" {}

provider "kubectl" {}

provider "kubernetes" {
  config_path = var.kube_path
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

