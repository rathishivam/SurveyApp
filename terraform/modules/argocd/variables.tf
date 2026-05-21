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

variable "argocd_app_enabled" {
  type        = bool
  description = "Enable creation of an ArgoCD Application resource."
  default     = true
}

variable "argocd_app_name" {
  type        = string
  description = "Name of the ArgoCD Application to manage the repository"
  default     = "survey-app"
}

variable "argocd_app_project" {
  type        = string
  description = "ArgoCD project used by the Application"
  default     = "default"
}

variable "argocd_app_repo_url" {
  type        = string
  description = "Git repository URL that ArgoCD should monitor"
  default     = ""
}

variable "argocd_app_repo_path" {
  type        = string
  description = "Path inside the Git repo to the Kubernetes manifests or Helm chart"
  default     = "."
}

variable "argocd_app_repo_revision" {
  type        = string
  description = "Git branch, tag, or revision for the ArgoCD Application"
  default     = "HEAD"
}

variable "argocd_app_destination_namespace" {
  type        = string
  description = "Namespace in the target cluster where the app should be deployed"
  default     = "default"
}

variable "argocd_app_sync_enabled" {
  type        = bool
  description = "Whether ArgoCD should enable automated sync for the application"
  default     = true
}

variable "argocd_app_prune" {
  type        = bool
  description = "Whether ArgoCD should prune resources that are removed from Git"
  default     = true
}

variable "argocd_app_self_heal" {
  type        = bool
  description = "Whether ArgoCD should self-heal drifted resources"
  default     = true
}
