resource "random_id" "prefix" {
  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name     = coalesce(var.resource_group_name, "${random_id.prefix.hex}-rg")
}

locals {
  resource_group = {
    name     = var.create_resource_group ? azurerm_resource_group.main[0].name : var.resource_group_name
    location = var.location
  }
}

resource "azurerm_virtual_network" "aks_network" {
  address_space       = ["10.200.0.0/16"]
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = local.resource_group.name

  depends_on = [
    azurerm_resource_group.main
  ]
}

resource "azurerm_subnet" "aks_subnet" {
  address_prefixes                          = ["10.200.0.0/22"]
  name                                      = "${random_id.prefix.hex}-sn"
  resource_group_name                       = local.resource_group.name
  virtual_network_name                      = azurerm_virtual_network.aks_network.name
  private_endpoint_network_policies_enabled = true

  depends_on = [
    azurerm_resource_group.main
  ]
}

# locals {
#   nodes = {
#     for i in range(1) : "worker${i}" => {
#       name           = substr("worker${i}${random_id.prefix.hex}", 0, 8)
#       vm_size        = "Standard_D2s_v3"
#       node_count     = 1
#       vnet_subnet_id = azurerm_subnet.aks_subnet.id
#     }
#   }
# }

module "aks" {
  source = "github.com/Azure/terraform-azurerm-aks"
  # version = "7.5.0"

  prefix              = "prefix" #"${random_id.prefix.hex}"
  resource_group_name = local.resource_group.name
  kubernetes_version  = "1.29"
  cluster_name        = "moh-aks-cluster"
  os_disk_size_gb     = 40
  # public_network_access_enabled = false
  sku_tier       = "Standard"
  rbac_aad       = false
  vnet_subnet_id = azurerm_subnet.aks_subnet.id
  # node_pools                    = local.nodes
  # node_count                    = 1

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Network configuration

  network_plugin      = "azure"
  network_plugin_mode = "overlay"
  network_policy      = "cilium"
  ebpf_data_plane   = "cilium"

  # Set node provisioning mode to Auto
  enable_auto_scaling = false # In order to use Karpenter enable_auto_scaling should be first.

  # agents_availability_zones = ["1", "2"]
  # agents_count              = null
  agents_max_count          = 5
  agents_max_pods           = 100 #40
  agents_min_count          = 1
  agents_pool_name          = "appnodepool"


  depends_on = [
    azurerm_resource_group.main
  ]
}

resource "null_resource" "karpenter" {

  provisioner "local-exec" {
    command = <<EOT
    az extension add --name aks-preview
    az feature register --namespace "Microsoft.ContainerService" --name "NodeAutoProvisioningPreview"
    az provider register --namespace Microsoft.ContainerService
    EOT
  }
} 