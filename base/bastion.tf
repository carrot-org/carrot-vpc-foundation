data "aws_ami" "amazon_bastion_ami" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "amzn2-ami-hvm-.+-x86_64-gp2$"
}

resource "aws_instance" "bastion" {
  depends_on = ["aws_security_group.bastion"]

  ami           = "${data.aws_ami.amazon_bastion_ami.id}"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.jenkins-user.key_name}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  subnet_id              = "${module.vpc.public_subnets[0]}"

  tags = {
    Name = "Bastion"
  }
}
