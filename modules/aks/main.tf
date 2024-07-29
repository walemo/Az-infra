resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_name
  location            = var.aks_location
  resource_group_name = var.aks_resource_group_name
  kubernetes_version  = var.aks_version
  dns_prefix          = var.aks_dns_prefix
  sku_tier            = var.sku_tier

  oidc_issuer_enabled       = var.oidc_issuer_enabled 
  workload_identity_enabled = var.workload_identity_enabled


   network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    network_policy      = var.network_policy
    ebpf_data_plane     = var.ebpf_data_plane
  }

  default_node_pool {
    name                = var.default_node_pool_name
    vnet_subnet_id      = var.default_node_pool_vnet_subnet_id
    node_count          = var.default_node_pool_node_count
    vm_size             = var.default_node_pool_vm_size
    max_pods            = var.default_node_pool_max_pods
    enable_auto_scaling = var.enable_auto_scaling

    tags = var.node_pool_tags
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOT
      if [ "${var.install_karpenter}" = true ]; then
        az extension add --name aks-preview
        az aks update --name ${var.aks_name} --resource-group ${var.aks_resource_group_name} --node-provisioning-mode Auto
      fi
    EOT
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "extra_node_pool" {
  for_each = { for idx, pool in var.node_pools : idx => pool }

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  vnet_subnet_id        = each.value.vnet_subnet_id
  enable_auto_scaling   = each.value.enable_auto_scaling
  max_pods              = each.value.max_pods

  tags = each.value.tags
}
