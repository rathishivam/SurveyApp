variable "project" {
  type    = string
  default = "survey-app"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "argocd_app_project" {
  type        = string
  description = "ArgoCD project to assign the Application to"
  default     = "default"
}

variable "argocd_app_repo_url" {
  type        = string
  description = "Git repo URL that ArgoCD should monitor"
  default     = "https://github.com/example/survey-app.git"
}

variable "argocd_app_repo_path" {
  type        = string
  description = "Path inside the Git repo to the deployment manifests or chart"
  default     = "deploy/argocd"
}

variable "argocd_app_repo_revision" {
  type        = string
  description = "Git branch, tag, or revision for the ArgoCD Application"
  default     = "HEAD"
}

variable "argocd_app_destination_namespace" {
  type        = string
  description = "Namespace into which the ArgoCD Application should deploy resources"
  default     = "default"
}

variable "argocd_app_sync_enabled" {
  type        = bool
  description = "Enable automated sync for the ArgoCD Application"
  default     = true
}

variable "argocd_app_prune" {
  type        = bool
  description = "Enable pruning of resources removed from Git"
  default     = true
}

variable "argocd_app_self_heal" {
  type        = bool
  description = "Enable self-healing for the ArgoCD Application"
  default     = true
}
