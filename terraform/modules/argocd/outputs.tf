# ArgoCD module outputs

output "release_name" {
  description = "ArgoCD Helm release name"
  value       = module.argocd_helm.release_name
}

output "release_status" {
  description = "ArgoCD Helm release status"
  value       = module.argocd_helm.release_status
}
