//***************** AKS ***********************//

variable "aks_resource_group_name" {
  description = "The name of the resource group in which to create the Kubernetes cluster."
  type        = string
  default     = ""
}


variable "aks_name" {
  description = "The name of the AKS cluster."
  type        = string
}


variable "aks_location" {
  description = "The location/region where the Kubernetes cluster will be created."
  type        = string
}


variable "aks_version" {
  description = "The Kubernetes version to use for the cluster."
  type        = string
}


variable "aks_dns_prefix" {
  description = "The DNS prefix to use for the Kubernetes cluster."
  type        = string
}

variable "sku_tier" {
  description = "sku tier for the Kubernetes cluster."
  type        = string
}

variable "oidc_issuer_enabled" {
  description = "Whether the OIDC issuer is enabled for the cluster."
  type        = bool
}

variable "workload_identity_enabled" {
  description = "Whether workload identity is enabled for the cluster."
  type        = bool
}

variable "enable_auto_scaling" {
  description = "Whether auto-scaling is enabled for the default node pool."
  type        = bool
}

variable "network_plugin" {
  description = "The network plugin to use for the Kubernetes cluster."
  type        = string
  default     = "azure"
}

variable "network_plugin_mode" {
  description = "The network plugin mode to use for the Kubernetes cluster."
  type        = string
  default     = "overlay"
}

variable "network_policy" {
  description = "The network policy to use for the Kubernetes cluster."
  type        = string
  default     = "cilium"
}

variable "ebpf_data_plane" {
  description = "The eBPF data plane to use for the Kubernetes cluster."
  type        = string
  default     = "cilium"
}

variable "default_node_pool_name" {
  description = "The name of the default node pool."
  type        = string
  default     = "default"
}

variable "default_node_pool_vnet_subnet_id" {
  description = "The VNet subnet ID for the default node pool."
  type        = string
  default     = ""
}

variable "default_node_pool_node_count" {
  description = "The initial number of nodes for the default node pool."
  type        = number
  default     = 1
}

variable "default_node_pool_vm_size" {
  description = "The VM size for the default node pool."
  type        = string
  default     = "Standard_D2_v2"
}

variable "default_node_pool_max_pods" {
  description = "The maximum number of pods per node for the default node pool."
  type        = string
  default     = ""
}

variable "node_pool_tags" {
  description = "Tags to be applied to the default node pool."
  type        = map(string)
  default     = {}
}

variable "node_pools" {
  description = "List of node pools for the Kubernetes cluster."
  type = list(object({
    name                = string
    vm_size             = string
    node_count          = number
    vnet_subnet_id      = string
    enable_auto_scaling = bool
    max_pods            = number
    tags                = map(string)
  }))
  default = []
}

variable "install_karpenter" {
  description = "Flag to determine whether to install Karpenter."
  type        = bool
  default     = false
}





