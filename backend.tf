terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-a08"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    acl     = "bucket-owner-full-control"
  }
}