# VPC module outputs
# These values expose the created VPC and subnet resources to the calling module.

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = try(aws_nat_gateway.this[0].id, null)
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = try(aws_route_table.public[0].id, null)
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = try(aws_route_table.private[0].id, null)
}
