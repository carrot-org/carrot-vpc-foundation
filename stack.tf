provider "aws" {}

data "aws_region" "current" {}

locals {
  region = "${data.aws_region.current.name}"
  vpc_cidr = "10.0.0.0/16"
  vpc_azs = ["${local.region}a", "${local.region}b", "${local.region}c"]
  vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}


module "base" {
  source = "./base"

  container_instance_security_group_id = "${module.cluster.container_instance_security_group_id}"

  vpc_cidr = "${local.vpc_cidr}"
  vpc_azs = "${local.vpc_azs}"
  vpc_private_subnets = "${local.vpc_private_subnets}"
  vpc_public_subnets = "${local.vpc_public_subnets}"

  # Outputs:
  # vpc_id
  # vpc_private_subnets
  # key_pair_name
  # bastion_ip
  # vpc_public_subnets
}

module "cluster" {
  source = "./cluster"

  private_subnet_ids = "${local.vpc_private_subnets}"
  private_subnet_count = "${length(local.vpc_private_subnets)}"
  project_name       = "demo"
  environment        = "development"
  vpc_id             = "${module.base.vpc_id}"
  key_name           = "${module.base.key_pair_name}"

  # Outputs:
  # container_instance_security_group_id
  # cluster_name
}

module "app" {
  source                        = "./app"
  environment                   = "development"
  cluster_name                  = "${module.cluster.cluster_name}"
  ecs_cluster_security_group_id = "${module.cluster.container_instance_security_group_id}"
  vpc_public_subnets            = "${module.base.vpc_public_subnets}"
  vpc_private_subnets           = "${module.base.vpc_private_subnets}"
  vpc_id                        = "${module.base.vpc_id}"
}
