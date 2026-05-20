# Main VPC resource
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.tags, {
    Name        = var.vpc_name
    Environment = var.env
  })
}

# Internet Gateway for public internet access
resource "aws_internet_gateway" "this" {
  count  = var.enable_igw ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = var.igw_name
  })
}

# Public subnets in the VPC
resource "aws_subnet" "public" {
  for_each = { for idx, subnet in var.public_subnets : idx => subnet }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(var.tags, {
    Name = each.value.name
    Type = "public"
  })
}

# Private subnets in the VPC
resource "aws_subnet" "private" {
  for_each = { for idx, subnet in var.private_subnets : idx => subnet }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(var.tags, {
    Name = each.value.name
    Type = "private"
  })
}

# Elastic IP used by the NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway && length(aws_subnet.public) > 0 ? 1 : 0
  # vpc   = true

  tags = merge(var.tags, {
    Name = var.nat_gateway_name
  })
}

# NAT Gateway for private subnet outbound traffic
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway && length(aws_subnet.public) > 0 ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = element([for subnet in aws_subnet.public : subnet.id], 0)

  tags = merge(var.tags, {
    Name = var.nat_gateway_name
  })
}

# Route table for public subnets
resource "aws_route_table" "public" {
  count  = length(aws_subnet.public) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = var.public_route_table_name
  })
}

# Route from public route table to internet gateway
resource "aws_route" "public_internet" {
  count                  = var.enable_igw && length(aws_route_table.public) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

# Associate each public subnet with public route table
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

# Route table for private subnets
resource "aws_route_table" "private" {
  count  = length(aws_subnet.private) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = var.private_route_table_name
  })
}

# Route from private route table to NAT Gateway
resource "aws_route" "private_nat" {
  count                  = var.enable_nat_gateway && length(aws_route_table.private) > 0 ? 1 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

# Associate each private subnet with private route table
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}

