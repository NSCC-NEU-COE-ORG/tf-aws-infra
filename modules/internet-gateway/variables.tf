# modules/internet-gateway/variables.tf

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "gateway_name" {
  description = "The name of the Internet Gateway"
  type        = string
}