variable "create_resource_group" {
  type     = bool
  default  = true
  nullable = false
}

variable "location" {
  default = "canadacentral"
}

variable "tenant_id" {
  default = null
  type    = string
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "argocd_gitops_repositories" {
  description = "Map of GitOps Repositories for ArgoCD"
  type = map(object({
    url           = string
    type          = optional(string)
    username      = optional(string)
    password      = optional(string)
    sshPrivateKey = optional(string)
  }))
  default = {}
}

variable "argocd_config" {
  description = "Map of additional argocd configuration for argocd-cm configmap"
  type        = map(any)
}

# variable "github_app_id_base64" {
#   description = "The GitHub App ID to use with ArgoCD repository authentication"
#   type        = string
# }

# variable "github_app_installation_id_base64" {
#   description = "The GitHub Appp installation ID to use with ArgoCD repository authentication"
#   type        = string
# }

# variable "github_app_private_key_base64" {
#   description = "The GitHub Appp private key to use with ArgoCD repository authentication"
#   type        = string
# }

variable "gitops_project_base64" {
  description = "The GitOps project to use with ArgoCD repository authenticationr"
  type        = string
}

variable "gitops_type_base64" {
  description = "The type of authentication used for repository authentication with ArgoCD"
  type        = string
}

variable "gitops_repository_url_base64" {
  description = "The GitHub operational repository URL"
  type        = string
}

# variable "gitops_application_repository_url_base64" {
#   description = "The GitHub application repository URL"
#   type        = string
# }

variable "gitops_repository_url" {
  description = "The GitHub operational repository URL"
  type        = string
}

# variable "gitops_application_repository_url" {
#   description = "The GitHub application repository URL"
#   type        = string
# }

variable "gitops_application_env" {
  description = "The GitOps application environment name"
  type        = string
}

variable "gitops_operational_env" {
  description = "The GitOps operational environment name"
  type        = string
}

variable "gitops_client" {
  description = "The GitOps client name"
  type        = string
}

