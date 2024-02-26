
data "kubectl_path_documents" "kubernetes_manifests" {
  pattern = "./argocd-manifests/templates/*.yaml"
  vars = {
    # github_app_id_base64                     = var.github_app_id_base64
    # github_app_installation_id_base64        = var.github_app_installation_id_base64
    # github_app_private_key_base64            = var.github_app_private_key_base64
    gitops_project_base64                    = var.gitops_project_base64
    gitops_type_base64                       = var.gitops_type_base64
    gitops_operational_repository_url_base64 = var.gitops_operational_repository_url_base64
    gitops_application_repository_url_base64 = var.gitops_application_repository_url_base64
    gitops_operational_repo_url              = var.gitops_operational_repository_url
    gitops_application_repository_url        = var.gitops_application_repository_url
    gitops_client                            = var.gitops_client
    gitops_application_env                   = var.gitops_application_env
    gitops_operational_env                   = var.gitops_operational_env
  }
}

resource "kubectl_manifest" "kubernetes_manifests" {
  for_each  = toset(data.kubectl_path_documents.kubernetes_manifests.documents)
  yaml_body = each.value

  depends_on = [module.aks, module.argocd]
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


}