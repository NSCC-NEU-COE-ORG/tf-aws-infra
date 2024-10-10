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
