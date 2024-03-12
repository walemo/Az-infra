data "azurerm_subscription" "current" {}

data "azurerm_key_vault" "mohkeyv" {
  name                = "mohkeyv" // KeyVault name
  resource_group_name = "crossplane" // resourceGroup
}

resource "azurerm_user_assigned_identity" "mgd_id" {
  name                = "crossplane-mi"
  location            = var.location
  resource_group_name = var.resource_group_name
#   tags                = "${var.tags}"

   depends_on = [module.aks, helm_release.argocd]
}

resource "azurerm_role_definition" "role_def" {
  name        = "crossplane-role"
  scope       = data.azurerm_subscription.current.id
  description = "This is a custom role created via Terraform for Managed Identity crossplane-mi"

  permissions {
    actions     = ["*"] #["Microsoft.Resources/subscriptions/resourceGroups/read"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource "azurerm_role_assignment" "role_asn" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.role_def.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.mgd_id.principal_id

  depends_on = [module.aks, helm_release.argocd]
}

resource "azurerm_key_vault_access_policy" "kv_policy" {
  key_vault_id = data.azurerm_key_vault.mohkeyv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = azurerm_user_assigned_identity.mgd_id.principal_id

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
}