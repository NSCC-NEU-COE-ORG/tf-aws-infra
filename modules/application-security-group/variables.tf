variable "vpc_id" {
  description = "VPC ID to create subnets in"
  type        = string
}

variable "load_balancer_sg_id" {
  description = "The Security Group ID for the Load Balancer"
  type = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}