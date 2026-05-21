# Variables for RDS module

variable "name" {
  type        = string
  description = "Name/identifier for the RDS instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC id where RDS will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the DB subnet group (private subnets)"
}

variable "engine" {
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  default     = "15"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  default     = 20
}

variable "username" {
  type        = string
}

variable "password" {
  type        = string
  sensitive   = true
}

variable "port" {
  type        = number
  default     = 5432
}

variable "publicly_accessible" {
  type        = bool
  default     = false
}

variable "multi_az" {
  type        = bool
  default     = false
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to connect to the DB (for dev/testing)"
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "backup_retention_period" {
  type        = number
  default     = 0
}

variable "deletion_protection" {
  type        = bool
  default     = false
}
