module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v1.66.0"

  name = "jenkins-development"

  cidr = "${var.vpc_cidr}"

  azs             = "${var.vpc_azs}"
  private_subnets = "${var.vpc_private_subnets}"
  public_subnets  = "${var.vpc_public_subnets}"

  assign_generated_ipv6_cidr_block = true

  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "${var.vpc_public_subnet_name}"
  }

  tags = {
    Owner       = "jenkins"
    Environment = "development"
  }

  vpc_tags = {
    Name = "jenkins-development-vpc"
  }
}
