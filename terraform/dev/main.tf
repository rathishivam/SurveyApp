# Dev environment root module
# This configuration uses reusable modules for VPC, IAM, EKS, RDS, S3, CloudFront, addons, and ArgoCD.

# IAM module creates the EKS control plane and node IAM roles.
module "iam" {
  source = "../modules/iam"

  project = var.project
  env     = var.env
  tags    = merge(var.tags, { Service = "iam" })
}

# VPC module creates networking resources for the cluster and database.
module "vpc" {
  source = "../modules/vpc"

  vpc_name                 = var.vpc_name
  env                      = var.env
  cidr_block               = var.vpc_cidr
  enable_dns_support       = true
  enable_dns_hostnames     = true
  tags                     = merge(var.tags, { Project = var.project })
  enable_igw               = true
  igw_name                 = "${var.project}-${var.env}-igw"
  public_subnets           = var.public_subnets
  private_subnets          = var.private_subnets
  enable_nat_gateway       = var.enable_nat_gateway
  nat_gateway_name         = "${var.project}-${var.env}-nat"
  public_route_table_name  = "${var.project}-${var.env}-public-rt"
  private_route_table_name = "${var.project}-${var.env}-private-rt"
  cluster_name             = "${var.project}-${var.env}-eks"
}

# EKS module creates the cluster and a managed node group.
module "eks" {
  source = "../modules/eks"

  cluster_name     = "${var.project}-${var.env}-eks"
  cluster_version  = var.eks_cluster_version
  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  subnet_ids      = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  node_subnet_ids = module.vpc.private_subnet_ids

  node_instance_type = var.eks_node_instance_type
  node_desired_size  = var.eks_node_desired_size
  node_min_size      = var.eks_node_min_size
  node_max_size      = var.eks_node_max_size

  tags = merge(var.tags, { Service = "eks" })
}

# EKS addons module installs basic managed addons.
## Create OIDC provider for IRSA (uses cluster identity from created EKS cluster)
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# Fetch the OIDC provider certificate to dynamically extract the thumbprint
data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# Register the EKS OIDC provider in IAM so pods can assume roles via service accounts
resource "aws_iam_openid_connect_provider" "eks" {
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
}

# Example: create an IAM role that a Kubernetes ServiceAccount can assume (IRSA)
data "aws_iam_policy_document" "irsa_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")} :sub"
      values   = ["system:serviceaccount:default:survey-backend-sa"]
    }
  }
}

resource "aws_iam_role" "irsa_role" {
  name               = "${var.project}-${var.env}-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume.json

  tags = merge(var.tags, { Name = "${var.project}-${var.env}-irsa-role" })
}

resource "aws_iam_role_policy_attachment" "irsa_attach" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # example policy
}

# EKS addons module installs basic managed addons.
module "eks_addons" {
  source = "../modules/eks-addons"

  cluster_name = module.eks.cluster_name
  addon_names  = var.eks_addon_names
}

# RDS module creates a PostgreSQL instance in private subnets.
module "rds" {
  source = "../modules/rds"

  name                    = "${var.project}-${var.env}-db"
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnet_ids
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  port                    = var.db_port
  username                = var.db_username
  password                = var.db_password
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  allowed_cidr_blocks     = var.db_allowed_cidrs
  publicly_accessible     = var.db_publicly_accessible
  backup_retention_period = var.db_backup_retention_period
  deletion_protection     = var.db_deletion_protection

  tags = merge(var.tags, { Service = "rds" })
}

# S3 module creates a bucket for the UI assets.
module "ui_bucket" {
  source = "../modules/s3"

  bucket_name   = var.ui_bucket_name
  force_destroy = true
  tags          = merge(var.tags, { Service = "ui" })
}

# CloudFront module publishes the UI bucket through a CDN.
module "cdn" {
  source = "../modules/cloudfront"

  name                = "${var.project}-${var.env}-ui-cdn"
  bucket_name         = module.ui_bucket.bucket_name
  bucket_domain_name  = module.ui_bucket.bucket_regional_domain_name
  default_root_object = var.cloudfront_default_root_object
  tags                = merge(var.tags, { Service = "ui" })
}

# ArgoCD module installs ArgoCD into the EKS cluster using Helm.
module "argocd" {
  source = "../modules/argocd"

  release_name  = "${var.project}-${var.env}-argocd"
  chart_version = var.argocd_chart_version
  values = [<<YAML
server:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "alb"
      service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
dex:
  enabled: false
YAML
  ]

  depends_on = [module.eks_addons]
}

# Create ArgoCD Application resource to monitor the Git repository
resource "kubernetes_manifest" "argocd_application" {
  count = var.argocd_app_repo_url != "" ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "${var.project}-${var.env}-app"
      namespace = "argocd"
    }
    spec = {
      project = var.argocd_app_project
      source = {
        repoURL        = var.argocd_app_repo_url
        targetRevision = var.argocd_app_repo_revision
        path           = var.argocd_app_repo_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.argocd_app_destination_namespace
      }
      syncPolicy = var.argocd_app_sync_enabled ? {
        automated = {
          prune    = var.argocd_app_prune
          selfHeal = var.argocd_app_self_heal
        }
      } : null
    }
  }

  depends_on = [module.argocd]

  timeouts {
    create = "5m"
  }
}

# Outputs to verify deployment values.
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_endpoint" {
  value = module.eks.endpoint
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "ui_bucket_name" {
  value = module.ui_bucket.bucket_name
}

output "cdn_domain" {
  value = module.cdn.distribution_domain_name
}

output "argocd_release" {
  value = module.argocd.release_name
}

output "oidc_provider_arn" {
  description = "ARN of the created IAM OIDC provider for the EKS cluster"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "irsa_role_arn" {
  description = "Example IRSA IAM role ARN created for service account"
  value       = aws_iam_role.irsa_role.arn
}
