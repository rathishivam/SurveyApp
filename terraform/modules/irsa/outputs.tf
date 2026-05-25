output "oidc_provider_arn" {
  description = "ARN of the EKS cluster OIDC provider"
  value       = var.openid_eks_arn
}

output "irsa_role_arn" {
  description = "ARN of the created IRSA IAM role"
  value       = aws_iam_role.irsa_role.arn
}

output "irsa_role_name" {
  description = "Name of the created IRSA IAM role"
  value       = aws_iam_role.irsa_role.name
}

output "oidc_issuer" {
  description = "OIDC issuer URL for the EKS cluster"
  value       = var.oidc_provider_url
}
