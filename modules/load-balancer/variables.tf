variable "security_group_id" {
  description = "security group id"
}


variable "s3_bucket_id" {
  description = "S3 Bucket ID"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}