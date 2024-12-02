output "kms_keys" {
  value = {
    ec2    = aws_kms_key.ec2_key.arn
    rds    = aws_kms_key.rds_key.arn
    s3     = aws_kms_key.s3_key.arn
    secret = aws_kms_key.secrets_key.arn
  }
}