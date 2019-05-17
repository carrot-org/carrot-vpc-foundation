provider "aws" {
  region = "us-west-1"
}

module "base" {
  source = "./base"

  container_instance_security_group_id = "${module.cluster.container_instance_security_group_id}"

  # Outputs:
  # vpc_id
  # vpc_private_subnets
  # key_pair_name
  # bastion_ip
  # vpc_public_subnets
}

module "cluster" {
  source = "./cluster"

  private_subnet_ids = "${module.base.vpc_private_subnets}"
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
