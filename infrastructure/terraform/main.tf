provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "network" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  name_prefix          = local.name_prefix
}

module "compute" {
  source = "./modules/ec2"

  vpc_id        = module.network.vpc_id
  subnet_ids    = module.network.public_subnet_ids
  instance_type = var.instance_type
  key_name      = var.key_name
  allowed_ports = var.allowed_ports
  name_prefix   = local.name_prefix
}

module "messaging" {
  source = "./modules/sqs"

  name_prefix = local.name_prefix
}

module "database" {
  source = "./modules/rds"

  name_prefix           = local.name_prefix
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  app_security_group_id = module.compute.security_group_id
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
}
