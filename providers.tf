terraform {
  required_version = ">=1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.51, < 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
     helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "moh-aks-cluster"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  use_oidc = true
  subscription_id = "32eb20d3-efa4-4a51-a2ff-32721933e3dd"
}

provider "random" {}

# provider "helm" {
#   kubernetes {
#     host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
#     client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
#     client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
#     cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
#   }
# }

# data "aws_aks_cluster_auth" "cluster" {
#   name = module.aks_cluster_name.aks_id
# }

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}