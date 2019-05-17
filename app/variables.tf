variable "environment" {}
variable "ecs_cluster_security_group_id" {}
variable "cluster_name" {}

variable "vpc_public_subnets" {
  type = "list"
}

variable "vpc_private_subnets" {
  type = "list"
}

variable "vpc_id" {}
