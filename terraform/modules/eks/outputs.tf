# EKS module outputs

output "cluster_name" {
  description = "Created EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "endpoint" {
  description = "EKS cluster endpoint URL"
  value       = aws_eks_cluster.this.endpoint
}

output "certificate_authority_data" {
  description = "Base64 encoded CA data for the EKS cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}
