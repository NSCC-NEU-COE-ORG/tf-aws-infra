variable "security_group_id" {
  description = "security group id"
}


variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI image id"
  type        = string
}