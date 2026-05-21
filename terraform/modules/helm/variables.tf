# Helm module variables

variable "release_name" {
  type        = string
  description = "Name of the Helm release"
}

variable "chart" {
  type        = string
  description = "Helm chart name"
}

variable "repository" {
  type        = string
  description = "Helm chart repository URL"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version"
  default     = ""
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for the release"
  default     = "default"
}

variable "create_namespace" {
  type        = bool
  description = "Create namespace if it does not exist"
  default     = true
}

variable "values" {
  type        = list(string)
  description = "List of YAML values for the Helm release"
  default     = []
}

variable "set_values" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Optional Helm set values"
  default     = []
}
