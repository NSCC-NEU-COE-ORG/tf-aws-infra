output "rds_endpoint" {
  value       = aws_db_instance.csye6225_rds.endpoint
  description = "The endpoint of the RDS instance"
}