output "oidc_provider_arn" {
  description = "ARN of the created IAM OIDC provider for the EKS cluster"
  value       = aws_iam_openid_connect_provider.eks.arn
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
  value       = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
