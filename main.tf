
provider "aws" {
  region = var.aws_region
}

resource "random_string" "suffix" {
  length = 6
}

resource "random_password" "db_password" {
  length  = 16
  special = true
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

module "load_balancer_security_group" {
  source = "./modules/load-balancer-security-group"
  vpc_id = module.vpc.vpc_id
}

module "security_group" {
  source              = "./modules/application-security-group"
  vpc_id              = module.vpc.vpc_id
  cidr_block          = var.vpc_cidr
  load_balancer_sg_id = module.load_balancer_security_group.load_balancer_sg_id
}


module "db-security-group" {
  source            = "./modules/db-security-group"
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.security_group.security_group_id
}

module "rds" {
  source               = "./modules/rds"
  parameter_group_id   = module.db-security-group.db_security_group_id
  db_security_group_id = module.db-security-group.db_security_group_id
  private_subnets      = module.subnets.private_subnet_ids
  database_password    = var.database_password
}

module "s3-bucket" {
  source = "./modules/s3-bucket"
}

module "application-load-balancer" {
  source            = "./modules/load-balancer"
  s3_bucket_id      = module.s3-bucket.s3_bucket_id
  security_group_id = module.load_balancer_security_group.load_balancer_sg_id
  public_subnets    = module.subnets.public_subnet_ids
  vpc_id            = module.vpc.vpc_id
}

module "ec2-scale-deployment" {
  source                   = "./modules/ec2-scale-deployment"
  public_subnets           = module.subnets.public_subnet_ids
  security_group_id        = module.security_group.security_group_id
  rds_endpoint             = module.rds.rds_endpoint
  database_password        = var.database_password
  s3_bucket_id             = module.s3-bucket.s3_bucket_id
  aws_region               = var.aws_region
  web_app_target_group_arn = module.application-load-balancer.web_app_target_group_arn
  sns_topic_arn            = module.sns.sns_topic_arn
}

module "route-53" {
  source      = "./modules/route-53"
  lb_dns_name = module.application-load-balancer.lb_dns_name
  lb_zone_id  = module.application-load-balancer.lb_zone_id
}

module "sns" {
  source = "./modules/sns"
}


module "lambda" {
  source                    = "./modules/lambda-functions"
  sns_topic_arn             = module.sns.sns_topic_arn
  s3_bucket_lambda_function = var.s3_bucket_lambda_function
  lambda_jar_key            = var.lambda_jar_key
  domain_name               = var.domain_name != null ? var.domain_name : module.application-load-balancer.lb_dns_name
  mailgun_domain_name       = var.mailgun_domain_name
  mailgun_api_key           = var.mailgun_api_key
  aws_region                = var.aws_region
}

module "kms" {
  source              = "./modules/kms"
  database_password   = random_password.db_password.result
  mailgun_api_key     = var.mailgun_api_key
  mailgun_domain_name = var.mailgun_domain_name
}