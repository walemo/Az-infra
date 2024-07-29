resource "helm_release" "kubernetes_external_secrets" {

  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.9.8"
  namespace        = "external-secrets"
  create_namespace = true

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  # set {
  #   name  = "env.AWS_REGION"
  #   value = "eu-west-1"
  # }

  set {
    name  = "env.LOG_LEVEL"
    value = "info"
  }


  depends_on = [module.aks]

}