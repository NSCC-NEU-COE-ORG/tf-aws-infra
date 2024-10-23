output "db_security_group_id" {
  value       = aws_security_group.db_security_group.id
  description = "The security group ID for the RDS instance"
}


output "db_security_group_name" {
  value       = aws_security_group.db_security_group.name
  description = "The name of the RDS database security group"
}

output "db_security_group_vpc_id" {
  value       = aws_security_group.db_security_group.vpc_id
  description = "The VPC ID associated with the RDS security group"
}

output "db_parameter_group_name" {
  value       = aws_db_parameter_group.db_parameter_group.name
  description = "The name of the DB parameter group"
}

output "db_parameter_group_id" {
  value       = aws_db_parameter_group.db_parameter_group.id
  description = "The ID of the DB parameter group"
}

output "db_parameter_group_arn" {
  value       = aws_db_parameter_group.db_parameter_group.arn
  description = "The ARN of the DB parameter group"
}
