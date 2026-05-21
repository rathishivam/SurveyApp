# ArgoCD module
# Installs ArgoCD into the EKS cluster using the Helm module.

module "argocd_helm" {
  source = "../helm"

  release_name     = var.release_name
  chart            = var.chart
  repository       = var.repository
  chart_version    = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  values           = var.values
}

