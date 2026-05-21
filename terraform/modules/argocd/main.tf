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

resource "kubernetes_manifest" "argocd_application" {
  count = var.argocd_app_enabled && length(trim(var.argocd_app_repo_url)) > 0 ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = var.argocd_app_name
      namespace = var.namespace
    }
    spec = {
      project = var.argocd_app_project
      source = {
        repoURL        = var.argocd_app_repo_url
        targetRevision = var.argocd_app_repo_revision
        path           = var.argocd_app_repo_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.argocd_app_destination_namespace
      }
      syncPolicy = var.argocd_app_sync_enabled ? {
        automated = {
          prune    = var.argocd_app_prune
          selfHeal = var.argocd_app_self_heal
        }
      } : null
    }
  }

  depends_on = [module.argocd_helm]
}
