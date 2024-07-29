resource_group_name = "moh-aks"
tenant_id           = "fc7b5d97-b382-4536-9930-210792faa5c2"

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
gitops_project_base64        = "bW9o"
gitops_type_base64           = "Z2l0"
gitops_repository_url_base64 = "aHR0cHM6Ly9naXRodWIuY29tL3dhbGVtby9Bei1naXRvcHMuZ2l0"
# gitops_application_repository_url_base64 = ""
# gitops_operational_repository_url        = ""
gitops_repository_url  = "https://github.com/walemo/Az-gitops.git"
gitops_application_env = "dev"
gitops_operational_env = "dev"
gitops_client          = "mo"


#--------------------------------------------------------------------------------------------------
# AKS cluster configuration
#--------------------------------------------------------------------------------------------------
aks_name                = "moh-aks-cluster"
aks_location            = "canadacentral"
aks_resource_group_name = "moh-aks-rg"
aks_version             = "1.29"
aks_dns_prefix          = "mo"
sku_tier                = "Standard"

# Feature Flags
oidc_issuer_enabled       = true
workload_identity_enabled = true
enable_auto_scaling       = true
install_karpenter         = true

# Default Node Pool Configuration
# default_node_pool_name           = "default"
# default_node_pool_vnet_subnet_id = "/subscriptions/your_subscription_id/resourceGroups/your_resource_group/providers/Microsoft.Network/virtualNetworks/your_vnet/subnets/default"
# default_node_pool_node_count     = 1
# default_node_pool_vm_size        = "Standard_D2_v2"
# default_node_pool_max_pods       = 30

# node_pool_tags = {
#   Environment = "Production"
# }

# Additional Node Pools
# node_pools = [
#   {
#     name                = "np1"
#     vm_size             = "Standard_D2_v2"
#     node_count          = 2
#     # vnet_subnet_id      = ""
#     enable_auto_scaling = true
#     max_pods            = 30
#     tags = {
#       Role = "frontend"
#     }
#   }
  # ,
  # {
  #   name                = "np2"
  #   vm_size             = "Standard_D8_v3"
  #   node_count          = 3
  #   vnet_subnet_id      = ""
  #   enable_auto_scaling = false
  #   max_pods            = 60
  #   tags = {
  #     Role = "backend"
  #   }
  # }
# ]

# Network Configuration
network_plugin      = "azure"
network_plugin_mode = "overlay"
network_policy      = "cilium"
ebpf_data_plane     = "cilium"