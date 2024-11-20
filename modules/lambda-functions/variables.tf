variable "domain_name" {
  description = "Domain name for generating verification links"
  type        = string
}

variable "mailgun_domain_name" {
  description = "MailGun Domain name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "mailgun_api_key" {
  description = "MailGun API Key"
  type        = string
}

variable "s3_bucket_lambda_function" {
  description = "S3 bucket name for lambda function"
  type        = string
}

variable "lambda_jar_key" {
  description = "location of jar in lambda function."
  default     = ""
}