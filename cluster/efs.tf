resource "aws_efs_file_system" "jenkins-efs" {
  creation_token = "${var.environment}-jenkins-efs"

  encrypted = "true"

  tags = {
    Name = "${var.environment}-jenkins-efs"
  }
}

resource "aws_efs_mount_target" "target" {
  count = "${length(var.private_subnet_ids)}"

  file_system_id  = "${aws_efs_file_system.jenkins-efs.id}"
  subnet_id       = "${element(var.private_subnet_ids, count.index)}"
  security_groups = ["${aws_security_group.efs-ecs.id}"]
}

resource "aws_security_group" "efs-ecs" {
  name        = "efs-ecs"
  description = "From ECS Allow All Traffic To EFS"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${module.container_service_cluster.container_instance_security_group_id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${module.container_service_cluster.container_instance_security_group_id}"]
  }
}
