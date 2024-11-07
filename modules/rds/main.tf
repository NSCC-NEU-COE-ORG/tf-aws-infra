resource "aws_db_instance" "csye6225_rds" {
  allocated_storage      = 20
  engine                 = "mysql"       # Change to mariadb or postgres if required
  instance_class         = "db.t3.micro" # Cheapest instance class
  username               = "csye6225"
  password               = var.database_password
  parameter_group_name   = "csye6225-db-parameter-group"
  db_subnet_group_name   = aws_db_subnet_group.private_subnets.name # Private subnet group for RDS
  vpc_security_group_ids = [var.db_security_group_id]               # Attach DB security group
  publicly_accessible    = false                                    # Restrict public access
  multi_az               = false                                    # No Multi-AZ deployment
  skip_final_snapshot    = true
  tags = {
    Name = "csye6225-db-instance"
  }
}


resource "aws_db_subnet_group" "private_subnets" {
  name        = "rds-pprivate-subnet-group"
  description = "Private subnet group for RDS"
  subnet_ids  = var.private_subnets # List of private subnet IDs

  tags = {
    Name = "Private Subnets for RDS"
  }
}