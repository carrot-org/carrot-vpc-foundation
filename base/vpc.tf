module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-development"

  cidr = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.103.0/24"]

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
