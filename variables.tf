variable "aws_region" {
  description = "The AWS region where resources will be created"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "gateway_name" {
  description = "The name of the Internet Gateway"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of Availability zones"
  type        = list(string)
}

variable "database_password" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}

variable "s3_bucket_lambda_function" {
  description = "S3 bucket for Lambda deployment"
  type        = string
}

variable "lambda_jar_key" {
  description = "S3 object key for the Lambda function ZIP file"
  type        = string
}

variable "mailgun_api_key" {
  description = "SES source email for sending emails"
  type        = string
}

variable "mailgun_domain_name" {
  default = ""
}

variable "domain_name" {
  description = "The domain name for the lambda function. Defaults to the load balancer's DNS name if not provided."
  type        = string
  default     = null
}