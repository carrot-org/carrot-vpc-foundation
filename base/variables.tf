variable "container_instance_security_group_id" {}

variable "vpc_public_subnet_name" {
  default = "jenkins-public"
}

variable "vpc_cidr" {}

variable "vpc_azs" {
  type = "list"
}

variable "vpc_private_subnets" {
  type = "list"
}

variable "vpc_public_subnets" {
  type = "list"
}