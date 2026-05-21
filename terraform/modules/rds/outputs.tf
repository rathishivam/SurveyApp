# Outputs for RDS module

output "instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.id
}

output "address" {
  description = "RDS endpoint address"
  value       = aws_db_instance.this.address
}

output "endpoint" {
  description = "RDS endpoint (address:port)"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "RDS listening port"
  value       = aws_db_instance.this.port
}
