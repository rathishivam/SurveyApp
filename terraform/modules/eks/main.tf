# EKS module
# Creates an EKS cluster and a managed node group.
locals {
  oidc_provider_url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "tls_certificate" "cluster" {
  url = local.oidc_provider_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = local.oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
}
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.cluster_version
  vpc_config {
    subnet_ids = var.subnet_ids

    endpoint_public_access = true
    endpoint_private_access = false
  }

  tags = merge(var.tags, {
    Name = var.cluster_name
  })
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.node_subnet_ids
  instance_types  = [var.node_instance_type]

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-nodegroup"
  })
}
