# output "aks_named_id" {
#   value = module.aks.aks_id
# }

# output "kube_config" {
#   value = module.aks.kube_config_raw

#   sensitive = true
# }
output "mi_id" {
  value = azurerm_user_assigned_identity.mgd_id.id
}

output "mi_principal_id" {
  value = azurerm_user_assigned_identity.mgd_id.principal_id
}

output "mi_client_id" {
  value = azurerm_user_assigned_identity.mgd_id.client_id
}