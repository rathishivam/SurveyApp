aws_region = "ap-south-1"
project    = "survey-app"
env        = "dev"
vpc_name   = "survey-app-dev-vpc"
vpc_cidr   = "10.1.0.0/16"
tags = {
  Environment = "dev"
  Project     = "survey-app"
}

enable_nat_gateway = true
public_subnets = [
  {
    name                    = "survey-public-1"
    cidr_block              = "10.1.1.0/24"
    availability_zone       = "ap-south-1a"
    map_public_ip_on_launch = true
  },
  {
    name                    = "survey-public-2"
    cidr_block              = "10.1.2.0/24"
    availability_zone       = "ap-south-1b"
    map_public_ip_on_launch = true
  }
]
private_subnets = [
  {
    name              = "survey-private-1"
    cidr_block        = "10.1.3.0/24"
    availability_zone = "ap-south-1a"
  },
  {
    name              = "survey-private-2"
    cidr_block        = "10.1.4.0/24"
    availability_zone = "ap-south-1b"
  }
]
eks_cluster_version            = "1.35"
eks_node_instance_type         = "t3a.medium"
eks_node_desired_size          = 2
eks_node_min_size              = 2
eks_node_max_size              = 2
eks_addon_names                = ["vpc-cni", "coredns", "kube-proxy"]
irsa_lb_controller_role_name = "survey-app-lb-controller-irsa-role"
irsa_vpc_cni_role_name = "survey-app-vpc-cni-irsa-role"
vpc_cni_irsa_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
vpc_cni_sa_name ="aws-node"
vpc_cni_namespace = "kube-system"
aws_lb_controller_service_account_name = "aws-load-balancer-controller"
aws_lb_controller_chart_version = "1.4.0"
aws_lb_controller_irsa_policy_arns = ["arn:aws:iam::779403607170:policy/AWSLoadBalancerControllerIAMPolicy"]
ui_bucket_name                 = "survey-app-dev-ui-bucket"
cloudfront_default_root_object = "index.html"
argocd_chart_version           = "5.47.0"
argocd_app_project             = "default"
argocd_app_repo_url            = "https://github.com/rathishivam/SurveyApp.git"
argocd_app_repo_path           = "deploy/argocd"
argocd_app_repo_revision       = "main"
argocd_app_destination_namespace = "survey-app"
argocd_app_sync_enabled        = true
argocd_app_prune               = true
argocd_app_self_heal           = true
argocd_ingress_host = "argocd.rathilabs.space"
argocd_acm_certificate_arn = "arn:aws:acm:ap-south-1:779403607170:certificate/46d6e224-d50e-4801-9d66-97f0206bdc36"
db_engine                      = "postgres"
db_engine_version              = "15"
db_port                        = 5432
db_username                    = "survey_user"
db_password                    = "survey_pass_123"
db_instance_class              = "db.t3.micro"
db_allocated_storage           = 20
db_allowed_cidrs               = ["0.0.0.0/0"]
db_publicly_accessible         = false
db_backup_retention_period     = 0
db_deletion_protection         = false
