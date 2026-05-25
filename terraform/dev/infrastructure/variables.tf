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
  default = "1.29"
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
  default = ["vpc-cni", "coredns", "kube-proxy", "aws-ebs-csi-driver"]
}

variable "aws_lb_controller_chart_version" {
  type    = string
  default = ""
}

variable "aws_lb_controller_service_account_name" {
  type    = string
  default = "aws-load-balancer-controller"
}

variable "argocd_ingress_host" {
  type    = string
  default = "argocd.rathilabs.space"
}

variable "argocd_acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for ArgoCD ALB TLS"
  default     = ""
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

variable "irsa_service_account_name" {
  type    = string
  default = "survey-backend-sa"
}

variable "irsa_service_account_namespace" {
  type    = string
  default = "default"
}

variable "irsa_policy_arns" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}

variable "vpc_cni_namespace" {
  type    = string
  default = "kube-system"
}

variable "vpc_cni_sa_name" {
  type    = string
  default = "aws-node"
}

variable "vpc_cni_irsa_policy_arns" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
}

variable "aws_lb_controller_service_account_namespace" {
  type    = string
  default = "kube-system"
}

variable "aws_lb_controller_irsa_policy_arns" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"]
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
variable "aws_lb_controller_irsa_policy_arns" {
  
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
