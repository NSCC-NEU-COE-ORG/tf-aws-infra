variable "parameter_group_id" {
  description = "RDS paramerer group name"
}

variable "db_security_group_id" {
  description = "DB security group ID"
}

variable "private_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "database_password" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}