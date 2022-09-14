module "vpc-template" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-template"
  cidr = var.vpc_cidr_template

  single_nat_gateway   = true
  azs                  = var.azs_template
  private_subnets      = var.private_subnets_template
  public_subnets       = var.public_subnets_template
  enable_dns_hostnames = true

  enable_nat_gateway = true
  enable_vpn_gateway = true
}