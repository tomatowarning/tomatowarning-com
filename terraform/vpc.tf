#module "vpc" {
#  providers = {
#    aws = aws.primary
#  }
#
#  source = "terraform-aws-modules/vpc/aws"
#
#  name = "${var.app_name}-vpc"
#  cidr = var.vpc_cidr
#
#  azs             = var.vpc_availability_zones
#  private_subnets = var.vpc_private_subnets
#  public_subnets  = var.vpc_public_subnets
#
#  enable_nat_gateway = false
#  enable_vpn_gateway = false
#
#  tags = {
#    Environment = var.environment
#    CostCenter = var.app_name
#  }
#}