output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw

  sensitive = true

}

output "client_key" {
  description = "The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_key
}

output "host" {
  description = "The `host_id` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].host
}


output "oidc_issuer_url" {
  description = "The `oidc url` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
}


output "cluster_ca_certificate" {
  description = "The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster."
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].cluster_ca_certificate
}

output "cluster_fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
  value       = azurerm_kubernetes_cluster.aks_cluster.fqdn
}

output "cluster_identity" {
  description = "The `azurerm_kubernetes_cluster`'s `identity` block."
  value       = try(azurerm_kubernetes_cluster.aks_cluster.identity[0], null)
}
