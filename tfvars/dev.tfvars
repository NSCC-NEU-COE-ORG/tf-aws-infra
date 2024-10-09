# AWS region where resources will be created
aws_region = "us-east-1"

# CIDR block for the VPC
vpc_cidr = "10.0.0.0/16"

# Name of the VPC
vpc_name = "dev-vpc"

# Public Subnets CIDR blocks
public_subnets = [
  "10.0.1.0/24", # Availability Zone 1
  "10.0.2.0/24", # Availability Zone 2
  "10.0.3.0/24"  # Availability Zone 3
]

# Private Subnets CIDR blocks
private_subnets = [
  "10.0.4.0/24", # Availability Zone 1
  "10.0.5.0/24", # Availability Zone 2
  "10.0.6.0/24"  # Availability Zone 3
]

# Availability Zones to be used
availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

gateway_name = "internet-gateway"

