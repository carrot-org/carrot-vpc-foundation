output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "key_pair_name" {
  value = "${aws_key_pair.jenkins-user.key_name}"
}

output "bastion_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "vpc_public_subnets" {
  value = "${module.vpc.public_subnets}"
}
