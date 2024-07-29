data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}



resource "azuread_application" "external_secret-operator" {
  display_name = "External secret operator"

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
      type = "Role"
    }

    resource_access {
      id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.ReadWrite"]
      type = "Scope"
    }
  }
}




# Create a service principal
resource "azuread_service_principal" "external_secret" {
  client_id = azuread_application.external_secret-operator.client_id
}


resource "azurerm_key_vault_access_policy" "sp_kv_policy" {
  key_vault_id = data.azurerm_key_vault.mohkeyv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = azuread_service_principal.external_secret.id

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt", "Update", "Create", "Import"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
}

resource "azuread_service_principal_password" "external_secret_pass" {
  service_principal_id = azuread_service_principal.external_secret.object_id
  # rotate_when_changed = {
  #   rotation = time_rotating.example.id
  # }
}


resource "kubernetes_secret" "azure_sp_secret" {
  metadata {
    name      = "azure-secret-sp"
    namespace = "crossplane-system" # Specify the appropriate namespace
  }

  data = {
    ClientID     = azuread_service_principal.external_secret.client_id
    ClientSecret = azuread_service_principal_password.external_secret_pass.value
  }

  depends_on = [module.aks, helm_release.argocd]
}
