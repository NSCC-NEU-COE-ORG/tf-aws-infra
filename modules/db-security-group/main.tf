resource "aws_security_group" "db_security_group" {
  name        = "rds-db-sg"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id # Replace with your VPC ID

  # Ingress rule for MySQL or PostgreSQL, allowing traffic only from the application security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-db-sg"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "csye6225-db-parameter-group"
  family      = "mysql8.0" # For MySQL 8.0, or change for your DB engine and version
  description = "Custom parameter group for csye6225"

  # Add any parameters you want to modify here
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

