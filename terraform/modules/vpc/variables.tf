# VPC module variables
# These values control VPC settings, subnet definitions, and routing resources.

variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
}

variable "env" {
  type        = string
  description = "Environment label for resources"
  default     = "dev"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS support in the VPC"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Additional tags for all created resources"
  default     = {}
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name used to tag subnets for Kubernetes discovery"
  default     = ""
}

variable "enable_igw" {
  type        = bool
  description = "Enable creation of an Internet Gateway for public subnets"
  default     = true
}

variable "igw_name" {
  type        = string
  description = "Name tag for the Internet Gateway"
  default     = "internet-gateway"
}

variable "public_subnets" {
  type = list(object({
    name                    = string
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  description = "List of public subnet definitions"
  default     = []
}

variable "private_subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  description = "List of private subnet definitions"
  default     = []
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable creation of a NAT Gateway for private subnet internet access"
  default     = true
}

variable "nat_gateway_name" {
  type        = string
  description = "Name tag for the NAT Gateway"
  default     = "nat-gateway"
}

variable "public_route_table_name" {
  type        = string
  description = "Name tag for the public route table"
  default     = "public-route-table"
}

variable "private_route_table_name" {
  type        = string
  description = "Name tag for the private route table"
  default     = "private-route-table"
}
