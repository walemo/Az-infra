locals {
  identity_name        = "moh_wi"
  resource_group_name  = var.resource_group_name
  location             = var.location
  namespace            = "crossplane-system"
  service_account_name = "workload-identity-sa"
}


resource "azurerm_user_assigned_identity" "for_wi" {
  name                = local.identity_name
  resource_group_name = local.resource_group_name
  location            = local.location

  depends_on = [module.aks, helm_release.argocd]
}

// Allow our identity to be assumed by a Pod in the cluster
resource "azurerm_federated_identity_credential" "for_wi" {
  name                = local.identity_name
  resource_group_name = local.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url // Use the output from above or if in the same file
  //issuer              = azurerm_kubernetes_cluster.example.oidc_issuer_url
  parent_id = azurerm_user_assigned_identity.for_wi.id
  subject   = "system:serviceaccount:${local.namespace}:${local.service_account_name}"
}


resource "azurerm_key_vault_access_policy" "wi_kv_policy" {
  key_vault_id = data.azurerm_key_vault.mohkeyv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = azurerm_user_assigned_identity.for_wi.principal_id

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
}

resource "kubernetes_service_account" "workload-identity-sa" {
  metadata {
    name      = local.service_account_name
    namespace = local.namespace
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.for_wi.client_id
      "azure.workload.identity/tenant-id" = data.azurerm_subscription.current.tenant_id

    }
  }
}


# resource "kubernetes_namespace" "crossplane-system" {
#   metadata {
#     name = local.namespace
#   }
# }

