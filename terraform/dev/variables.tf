# Dev environment variables
# These values are specific to the development environment.

variable "project" {
  type    = string
  default = "survey-app"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_name" {
  type    = string
  default = "survey-app-dev-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
  }
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "public_subnets" {
  type = list(object({
    name                    = string
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  default = [
    {
      name                    = "public-subnet-1"
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "ap-south-1a"
      map_public_ip_on_launch = true
    },
    {
      name                    = "public-subnet-2"
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "ap-south-1b"
      map_public_ip_on_launch = true
    }
  ]
}

variable "private_subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      name              = "private-subnet-1"
      cidr_block        = "10.0.11.0/24"
      availability_zone = "ap-south-1a"
    },
    {
      name              = "private-subnet-2"
      cidr_block        = "10.0.12.0/24"
      availability_zone = "ap-south-1b"
    }
  ]
}

variable "eks_cluster_version" {
  type    = string
  default = "1.28"
}

variable "eks_node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "eks_node_desired_size" {
  type    = number
  default = 2
}

variable "eks_node_min_size" {
  type    = number
  default = 1
}

variable "eks_node_max_size" {
  type    = number
  default = 3
}

variable "eks_addon_names" {
  type    = list(string)
  default = ["vpc-cni", "coredns", "kube-proxy"]
}

variable "ui_bucket_name" {
  type    = string
  default = "survey-app-dev-ui-bucket"
}

variable "cloudfront_default_root_object" {
  type    = string
  default = "index.html"
}

variable "argocd_chart_version" {
  type    = string
  default = "5.47.0"
}

variable "argocd_app_project" {
  type        = string
  description = "ArgoCD project to assign the Application to"
  default     = "default"
}

variable "argocd_app_repo_url" {
  type        = string
  description = "Git repo URL that ArgoCD should monitor"
  default     = "https://github.com/example/survey-app.git"
}

variable "argocd_app_repo_path" {
  type        = string
  description = "Path inside the Git repo to the deployment manifests or chart"
  default     = "deploy/argocd"
}

variable "argocd_app_repo_revision" {
  type        = string
  description = "Git branch, tag, or revision for the ArgoCD Application"
  default     = "HEAD"
}

variable "argocd_app_destination_namespace" {
  type        = string
  description = "Namespace into which the ArgoCD Application should deploy resources"
  default     = "default"
}

variable "argocd_app_sync_enabled" {
  type        = bool
  description = "Enable automated sync for the ArgoCD Application"
  default     = true
}

variable "argocd_app_prune" {
  type        = bool
  description = "Enable pruning of resources removed from Git"
  default     = true
}

variable "argocd_app_self_heal" {
  type        = bool
  description = "Enable self-healing for the ArgoCD Application"
  default     = true
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  type    = string
  default = "15"
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "db_username" {
  type        = string
  description = "Database username for the RDS instance"
}

variable "db_password" {
  type        = string
  description = "Database password for the RDS instance"
  sensitive   = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to connect to the DB (for dev/testing)"
  default     = ["0.0.0.0/0"]
}

variable "db_publicly_accessible" {
  type    = bool
  default = false
}

variable "db_backup_retention_period" {
  type    = number
  default = 0
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}

