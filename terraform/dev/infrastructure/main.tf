# Infrastructure-only Terraform configuration for dev environment.
# This includes VPC, IAM, EKS, RDS, UI hosting, and ArgoCD installation.

module "iam" {
  source = "../../modules/iam"

  project = var.project
  env     = var.env
  tags    = merge(var.tags, { Service = "iam" })
}

module "vpc" {
  source = "../../modules/vpc"

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

module "eks" {
  source = "../../modules/eks"

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

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}

data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

module "irsa" {
  source = "../../modules/irsa"
  project                   = var.project
  env                       = var.env
  cluster_name              = module.eks.cluster_name
  service_account_namespace = var.irsa_service_account_namespace
  service_account_name      = var.irsa_service_account_name
  policy_arns               = var.irsa_policy_arns
  tags                      = merge(var.tags, { Service = "irsa" })

  depends_on = [module.eks]
}
module "irsa_vpc_cni" {
    source = "../../modules/irsa"
    project = var.project
    env = var.env
    cluster_name = module.eks.cluster_name
    service_account_namespace = var.vpc_cni_namespace
    service_account_name = var.vpc_cni_sa_name
    policy_arns = var.vpc_cni_irsa_policy_arns
    depends_on = [module.eks]
}
data "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer

  depends_on = [module.irsa,module.eks]
}

resource "aws_iam_role" "lb_controller" {
  name               = "${var.project}-${var.env}-aws-lb-controller"
  assume_role_policy = data.aws_iam_policy_document.lb_controller_assume.json

  tags = merge(var.tags, { Name = "${var.project}-${var.env}-aws-lb-controller" })
}

resource "aws_iam_role_policy_attachment" "lb_controller_attach" {
  role       = aws_iam_role.lb_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
}

data "aws_iam_policy_document" "lb_controller_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:${var.aws_lb_controller_service_account_name}"]
    }
  }
}

module "eks_addons" {
  source = "../../modules/eks-addons"

  cluster_name = module.eks.cluster_name
  addon_names  = var.eks_addon_names
}

module "aws_lb_controller" {
  source = "../../modules/helm"

  release_name     = "aws-load-balancer-controller"
  chart            = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart_version    = var.aws_lb_controller_chart_version
  namespace        = "kube-system"
  create_namespace = false

  values = [<<YAML
clusterName: ${module.eks.cluster_name}
region: ${var.aws_region}
vpcId: ${module.vpc.vpc_id}
serviceAccount:
  create: true
  name: ${var.aws_lb_controller_service_account_name}
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.lb_controller.arn}
YAML
  ]

  depends_on = [aws_iam_role.lb_controller]
}

module "rds" {
  source = "../../modules/rds"

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

module "ui_bucket" {
  source = "../../modules/s3"

  bucket_name   = var.ui_bucket_name
  force_destroy = true
  tags          = merge(var.tags, { Service = "ui" })
}

module "cdn" {
  source = "../../modules/cloudfront"

  name                = "${var.project}-${var.env}-ui-cdn"
  bucket_name         = module.ui_bucket.bucket_name
  bucket_domain_name  = module.ui_bucket.bucket_regional_domain_name
  default_root_object = var.cloudfront_default_root_object
  tags                = merge(var.tags, { Service = "ui" })
}

module "argocd" {
  source = "../../modules/argocd"

  release_name  = "${var.project}-${var.env}-argocd"
  chart_version = var.argocd_chart_version
  values = [<<YAML
server:
  service:
    type: ClusterIP
  ingress:
    enabled: true
    ingressClassName: alb
    annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/certificate-arn: ${var.argocd_acm_certificate_arn}
    hosts:
      - host: ${var.argocd_ingress_host}
        paths:
          - path: /
            pathType: Prefix
    tls:
      - hosts:
          - ${var.argocd_ingress_host}
        secretName: argocd-tls
dex:
  enabled: false
YAML
  ]

  depends_on = [module.eks_addons, module.aws_lb_controller]
}


######## OUTPUTS ##########
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
  value       = module.irsa.oidc_provider_arn
}

output "irsa_role_arn" {
  description = "IRSA IAM role ARN created for service account"
  value       = module.irsa.irsa_role_arn
}
