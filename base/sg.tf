resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow all inbound traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

# resource "aws_security_group_rule" "container_instance_http_egress_self" {
#   type        = "egress"
#   from_port   = 80
#   to_port     = 80
#   protocol    = "tcp"
#   self = true

#   security_group_id = "${var.container_instance_security_group_id}"
# }

resource "aws_security_group_rule" "container_instance_ingress_self" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  self      = true

  security_group_id = "${var.container_instance_security_group_id}"
}

resource "aws_security_group_rule" "container_instance_permit_egress" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = "${var.container_instance_security_group_id}"
}

# resource "aws_security_group_rule" "container_instance_https_egress" {
#   type        = "egress"
#   from_port   = 443
#   to_port     = 443
#   protocol    = "tcp"
#   cidr_blocks = ["10.0.0.0/8"]

#   security_group_id = "${var.container_instance_security_group_id}"
# }

# resource "aws_security_group_rule" "container_instance_ssh_egress" {
#   type        = "egress"
#   from_port   = 22
#   to_port     = 22
#   protocol    = "tcp"
#   source_security_group_id = ["bastion"]

#   security_group_id = "${var.container_instance_security_group_id}"
# }

resource "aws_security_group_rule" "container_instance_vpc_ingress" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.0.0.0/8"]

  security_group_id = "${var.container_instance_security_group_id}"
}

resource "aws_security_group_rule" "container_instance_ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.bastion.id}"

  security_group_id = "${var.container_instance_security_group_id}"
}
