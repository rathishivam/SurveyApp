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
eks_cluster_version            = "1.28"
eks_node_instance_type         = "t3.small"
eks_node_desired_size          = 2
eks_node_min_size              = 1
eks_node_max_size              = 2
eks_addon_names                = ["vpc-cni", "coredns", "kube-proxy"]
ui_bucket_name                 = "survey-app-dev-ui-bucket"
cloudfront_default_root_object = "index.html"
argocd_chart_version           = "5.47.0"
argocd_app_project             = "default"
argocd_app_repo_url            = "https://github.com/example/survey-app.git"
argocd_app_repo_path           = "deploy/argocd"
argocd_app_repo_revision       = "main"
argocd_app_destination_namespace = "survey-app"
argocd_app_sync_enabled        = true
argocd_app_prune               = true
argocd_app_self_heal           = true

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
