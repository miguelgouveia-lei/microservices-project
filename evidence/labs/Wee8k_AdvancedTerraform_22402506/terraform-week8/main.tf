provider "aws" {
  region = var.aws_region
}

locals {
  name_prefix = "week8-${terraform.workspace}"
}

module "network" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  name_prefix         = local.name_prefix
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
