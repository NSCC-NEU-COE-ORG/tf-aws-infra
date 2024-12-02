variable "database_password" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}

variable "mailgun_api_key" {
  description = "SES source email for sending emails"
  type        = string
}

variable "mailgun_domain_name" {
  default = ""
}