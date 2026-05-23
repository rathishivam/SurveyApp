locals {
  irsa_role_name = var.role_name != "" ? var.role_name : "${var.project}-${var.env}-irsa-role"
  oidc_provider_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  service_account_subject = "${replace(local.oidc_provider_url, "https://", "")}:sub"
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "tls_certificate" "cluster" {
  url = local.oidc_provider_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = local.oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "irsa_role" {
  name               = local.irsa_role_name
  assume_role_policy = data.aws_iam_policy_document.irsa_assume.json

  tags = merge(var.tags, { Name = local.irsa_role_name })
}

resource "aws_iam_role_policy_attachment" "irsa_attach" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.irsa_role.name
  policy_arn = each.value
}

data "aws_iam_policy_document" "irsa_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = local.service_account_subject
      values   = ["system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"]
    }
  }
}
