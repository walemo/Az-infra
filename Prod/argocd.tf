data "azurerm_key_vault" "gh_secret_rg" {
  name                = "MohWarChest" // KeyVault name
  resource_group_name = "crossplane"  // resourceGroup
}

data "azurerm_key_vault_secret" "gh_secret" {
  name         = "gh-secret" // Name of secret
  key_vault_id = data.azurerm_key_vault.gh_secret_rg.id
}


data "kubectl_path_documents" "kubernetes_manifests" {
  pattern = "../argocd-manifests/templates/*.yaml"
  vars = {
    # github_app_id_base64                     = var.github_app_id_base64
    # github_app_installation_id_base64        = var.github_app_installation_id_base64
    # github_app_private_key_base64            = var.github_app_private_key_base64
    gitops_project_base64        = var.gitops_project_base64
    gitops_type_base64           = var.gitops_type_base64
    gitops_repository_url_base64 = var.gitops_repository_url_base64
    # gitops_application_repository_url_base64 = var.gitops_application_repository_url_base64
    gitops_repo_url = var.gitops_repository_url
    # gitops_application_repository_url        = var.gitops_application_repository_url
    gitops_client          = var.gitops_client
    gitops_application_env = var.gitops_application_env
    gitops_operational_env = var.gitops_operational_env
  }
}

resource "kubectl_manifest" "kubernetes_manifests" {
  for_each  = toset(data.kubectl_path_documents.kubernetes_manifests.documents)
  yaml_body = each.value

  depends_on = [module.aks, helm_release.argocd]
}

# module "argocd" {
#   source        = "DeimosCloud/argocd/kubernetes"
#   version       = "1.1.2"
#   chart_version = "5.34.3"
#   repositories  = var.argocd_gitops_repositories
#   config        = var.argocd_config
#   # force_update  = true
#   # manifests     = {}
#   # manifests_directory = "./argocd-manifests"
# #   depends_on = [module.gke_zero]
# }

# data "kubectl_path_documents" "docs" {
#   pattern = "./argocd-manifests/*.yaml"
# }

resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.53.0"
  create_namespace = true

  #   values = concat(
  #     [yamlencode(local.values), yamlencode(var.values)],
  #     [for x in var.values_files : file(x)]
  #   )
  # }


  set {
    name  = "configs.repositories[0].url"
    value = "https://github.com/walemo/Az-gitops.git"
  }

  set_sensitive {
    name  = "configs.repositories[0].username"
    value = "Mohzeela"
  }

  set_sensitive {
    name  = "configs.repositories[0].password"
    value = data.azurerm_key_vault_secret.gh_secret.value
  }

  set {
    name  = "configs.argocd_config.kustomize.buildOptions"
    value = "--enable-helm --enable-alpha-plugins --enable-exec"
  }

  set {
    name  = "configs.argocd_config.statusbadge.enabled"
    value = "true"
  }

  depends_on = [module.aks]
}




