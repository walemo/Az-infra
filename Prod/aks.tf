module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "vnet" {
  source = "../modules/vnet"

  vnet_name            = "aks-vnet"
  vnet_address_space   = ["10.200.0.0/16"]
  subnets = [
    {
      name           = "ops-subnet"
      address_prefix = ["10.200.8.0/22"]
    },
    {
      name           = "apps-subnet"
      address_prefix = ["10.200.12.0/23"]
    }
  ]
  
  resource_group_name  = var.resource_group_name
  location             = var.location
}


module "aks" {
  source = "../modules/aks"

  aks_resource_group_name = var.resource_group_name
  aks_version  = "1.29"
  aks_name        = var.aks_name 
  aks_location = var.aks_location
  aks_dns_prefix = var.aks_dns_prefix
 
  sku_tier       = var.sku_tier
 


  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Network configuration
  network_plugin      = var.network_plugin
  network_plugin_mode = var.network_plugin_mode
  network_policy      = var.network_policy
  ebpf_data_plane     = var.ebpf_data_plane


  # Set node provisioning mode to Auto
  enable_auto_scaling = false # In order to use Karpenter enable_auto_scaling should be first.

  default_node_pool_name  = "ops"
  default_node_pool_vnet_subnet_id = module.vnet.subnet_ids["ops-subnet"]
  default_node_pool_node_count = 1
  default_node_pool_vm_size = "Standard_D2_v2"
  default_node_pool_max_pods = 50
  node_pool_tags = {
    Environment = "Production"
  }

  node_pools = [
    {
      name                = "apps"
      vm_size             = "Standard_D2_v2"
      node_count          = 1
      vnet_subnet_id      = module.vnet.subnet_ids["apps-subnet"]
      enable_auto_scaling = false
      max_pods            = 50
      tags = {
        Role = "apps"
      }
    }

  ]
  depends_on = [
    module.vnet
  ]

  install_karpenter = true
}

# resource "null_resource" "karpenter" {

#   provisioner "local-exec" {
#     command = <<EOT
#     az extension add --name aks-preview
#     az feature register --namespace "Microsoft.ContainerService" --name "NodeAutoProvisioningPreview"
#     az provider register --namespace Microsoft.ContainerService
#     EOT
#   }
# } 