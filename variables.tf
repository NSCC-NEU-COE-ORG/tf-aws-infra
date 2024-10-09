provider "random" {}

variable "aws_region" {
  description = "The AWS region where resources will be created"
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  default     = "" //refer main.tf, default will be assignment-vpc
}

variable "gateway_name" {
  description = "The name of the Internet Gateway"
  default     = "" // refer main.tf, default will be internet gateway
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "List of Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
