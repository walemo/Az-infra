resource_group_name = "moh-aks"
tenant_id = "fc7b5d97-b382-4536-9930-210792faa5c2"

#--------------------------------------------------------------------------------------------------
# ArgoCD/GitOps variables
#--------------------------------------------------------------------------------------------------
argocd_gitops_repositories = {
  # "ops-repo" = {
  #   url      = ""
  #   username = "needs_to_be_updated"
  #   password = "needs_to_be_updated"
  # },
  # "app-repo" = {
  #   url      = ""
  #   username = "needs_to_be_updated"
  #   password = "needs_to_be_updated"
  # }
}
argocd_config = {
  "kustomize.buildOptions" : "--enable-helm --enable-alpha-plugins --enable-exec"
  "statusbadge.enabled" : true
}

# github_app_id = ""
# github_app_installation_id = ""
# github_app_private_key = ""
gitops_project_base64                    = "bW9o"
gitops_type_base64                       = "Z2l0"
gitops_repository_url_base64 = "aHR0cHM6Ly9naXRodWIuY29tL3dhbGVtby9Bei1naXRvcHMuZ2l0"
# gitops_application_repository_url_base64 = ""
# gitops_operational_repository_url        = ""
gitops_repository_url        = "https://github.com/walemo/Az-gitops.git"
gitops_application_env                   = "dev"
gitops_operational_env                   = "dev"
gitops_client                            = "mo"
