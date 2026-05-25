variable "project" {
  type        = string
  description = "Project name used in generated IRSA role resources"
}

variable "env" {
  type        = string
  description = "Environment label used in generated IRSA role resources"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name for IRSA OIDC provider lookup"
}

variable "service_account_namespace" {
  type        = string
  description = "Kubernetes namespace of the service account that will assume the IRSA role"
  default     = "default"
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes service account name that will assume the IRSA role"
  default     = "survey-backend-sa"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of IAM policy ARNs to attach to the IRSA role"
  default     = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to IRSA-related IAM resources"
  default     = {}
}

variable "role_name" {
  type        = string
  description = "Optional explicit name for the IRSA IAM role"
  default     = ""
}

variable "openid_eks_arn" {
  type = string
}
variable "oidc_provider_url" {
  type = string
}