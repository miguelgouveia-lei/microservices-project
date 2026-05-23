module "vpc_public" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "week9-vpc"
  cidr = "10.50.0.0/16"

  azs             = ["eu-central-1a"]
  public_subnets  = ["10.50.1.0/24"]
  private_subnets = ["10.50.2.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Project = "CloudComputing"
  }
}
