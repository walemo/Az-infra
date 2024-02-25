resource_group_name = "moh-aks"

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
gitops_operational_repository_url_base64 = ""
gitops_application_repository_url_base64 = ""
gitops_operational_repository_url        = ""
gitops_application_repository_url        = ""
gitops_application_env                   = "dev"
gitops_operational_env                   = "dev"
gitops_client                            = "mo"
