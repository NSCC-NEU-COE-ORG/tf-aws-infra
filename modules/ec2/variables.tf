variable "security_group_id" {
  description = "security group id"
}


variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "rds_endpoint" {
  description = "RDS endpoint"
  type        = string
}

variable "database_password" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}

variable "s3_bucket_id" {
  description = "S3 Bucket ID"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources will be created"
}

variable "sns_topic_arn" {
  type        = string
  description = "ARN of the SNS topic for email notifications"
}