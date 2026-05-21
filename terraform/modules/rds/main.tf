# RDS module - simple, configurable Postgres instance

# Security group for RDS instance
resource "aws_security_group" "rds" {
  name   = "${var.name}-sg"
  vpc_id = var.vpc_id

  description = "Security group for RDS instance"

  # Allow inbound from configured CIDR blocks (for testing/dev)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-sg" })
}

# Subnet group for placing RDS in private subnets
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.name}-subnet-group" })
}

# RDS instance (single-instance Postgres for simplicity)
resource "aws_db_instance" "this" {
  identifier              = var.name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = var.publicly_accessible
  skip_final_snapshot     = true
  multi_az                = var.multi_az
  port                    = var.port

  # Minimal maintenance and backup settings for dev
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection

  tags = merge(var.tags, { Name = var.name })
}
