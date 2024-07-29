resource "helm_release" "crossplane-operator" {
  name = "crossplane"

  repository       = "https://charts.crossplane.io/stable"
  chart            = "crossplane"
  namespace        = "crossplane-system"
  version          = "1.15.1"
  create_namespace = true

  depends_on = [module.aks, helm_release.argocd]

}
