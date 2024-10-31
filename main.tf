provider "aws" {
  region = var.aws_region
}

resource "random_string" "suffix" {
  length = 6
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name != "" ? var.vpc_name : "assignment-vpc-${random_string.suffix.result}"
  cidr_block = var.vpc_cidr
}

module "subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}

module "internet_gateway" {
  source       = "./modules/internet-gateway"
  vpc_id       = module.vpc.vpc_id
  gateway_name = var.gateway_name != "" ? var.gateway_name : "assignment-igw-${random_string.suffix.result}"
}

module "route_tables" {
  source              = "./modules/route-tables"
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.subnets.public_subnet_ids
  private_subnets     = module.subnets.private_subnet_ids
  internet_gateway_id = module.internet_gateway.igw_id
}


module "application-security-group" {
  source = "./modules/application-security-group"
  vpc_id = module.vpc.vpc_id
}


module "db-security-group" {
  source            = "./modules/db-security-group"
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.application-security-group.security_group_id
}

module "rds" {
  source               = "./modules/rds"
  parameter_group_id   = module.db-security-group.db_parameter_group_id
  db_security_group_id = module.db-security-group.db_security_group_id
  private_subnets      = module.subnets.private_subnet_ids
  database_password    = var.database_password
}

module "s3-bucket" {
  source = "./modules/s3-bucket"
}

module "ec2" {
  source            = "./modules/ec2"
  public_subnets    = module.subnets.public_subnet_ids
  security_group_id = module.application-security-group.security_group_id
  ami_id            = var.ami_id
  rds_endpoint      = module.rds.rds_endpoint
  database_password = var.database_password
  s3_bucket_id      = module.s3-bucket.s3_bucket_id
  aws_region        = var.aws_region
}

module "route-53" {
  source             = "./modules/route-53"
  instance_public_ip = module.ec2.instance_public_ip
}

