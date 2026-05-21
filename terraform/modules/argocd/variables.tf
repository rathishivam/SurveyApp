# ArgoCD module variables

variable "release_name" {
  type        = string
  description = "Helm release name for ArgoCD"
}

variable "chart" {
  type        = string
  description = "Helm chart name for ArgoCD"
  default     = "argo-cd"
}

variable "repository" {
  type        = string
  description = "Helm repository URL for the ArgoCD chart"
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version for ArgoCD"
  default     = "5.47.0"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for ArgoCD"
  default     = "argocd"
}

variable "values" {
  type        = list(string)
  description = "Helm values for ArgoCD installation"
  default     = []
}
