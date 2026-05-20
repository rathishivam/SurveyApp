# Dev environment root module
# This file uses the shared VPC module from ../modules/vpc.

module "vpc" {
  source = "../modules/vpc"

  vpc_name                = var.vpc_name
  env                     = var.env
  cidr_block              = var.vpc_cidr
  enable_dns_support      = true
  enable_dns_hostnames    = true
  tags                    = merge(var.tags, { Project = var.project })
  enable_igw              = true
  igw_name                = "${var.project}-${var.env}-igw"
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  enable_nat_gateway      = var.enable_nat_gateway
  nat_gateway_name        = "${var.project}-${var.env}-nat"
  public_route_table_name = "${var.project}-${var.env}-public-rt"
  private_route_table_name = "${var.project}-${var.env}-private-rt"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
