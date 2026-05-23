# locals {
#   cluster_name = "${var.project}-${var.env}-eks"
# }

# data "aws_eks_cluster" "this" {
#   name = local.cluster_name
# }

# data "aws_eks_cluster_auth" "this" {
#   name = local.cluster_name
# }

resource "kubernetes_manifest" "argocd_application" {
  count = var.argocd_app_repo_url != "" ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name      = "${var.project}-${var.env}-app"
      namespace = "argocd"
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

  depends_on = [data.aws_eks_cluster.this]

  timeouts {
    create = "5m"
  }
}

output "argocd_application_name" {
  value       = length(kubernetes_manifest.argocd_application) > 0 ? kubernetes_manifest.argocd_application[0].manifest.metadata.name : ""
  description = "The name of the created ArgoCD Application"
}
