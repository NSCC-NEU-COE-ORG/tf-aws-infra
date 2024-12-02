resource "aws_kms_key" "ec2_key" {
  description             = "KMS key for EC2"
  enable_key_rotation     = true
}

resource "aws_kms_key" "rds_key" {
  description             = "KMS key for RDS"
  enable_key_rotation     = true
}

resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3"
  enable_key_rotation     = true
}

resource "aws_kms_key" "secrets_key" {
  description             = "KMS key for Secrets Manager"
  enable_key_rotation     = true
}

resource "aws_secretsmanager_secret" "db_password" {
  name              = "rdsdbpassword"
  kms_key_id        = aws_kms_key.secrets_key.id
}

resource "aws_secretsmanager_secret" "email_service" {
  name              = "email-service-credentials"
  kms_key_id        = aws_kms_key.secrets_key.id
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    password = var.database_password
  })
}

resource "aws_secretsmanager_secret_version" "email_service_version" {
  secret_id = aws_secretsmanager_secret.email_service.id
  secret_string = jsonencode({
    api_key = var.mailgun_api_key
    domain  = var.mailgun_domain_name
  })
}