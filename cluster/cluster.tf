data "template_file" "container_instance_cloud_config" {
  template = "${file("cluster/cloud-config/container-instance.yml.tpl")}"

  vars {
    environment             = "${var.environment}"
    ecs_cluster_name        = "${module.container_service_cluster.name}"
    efs_file_system_id_01   = "${aws_efs_file_system.jenkins-efs.id}"
    efs_file_system_path_01 = "jenkins"
  }
}

data "aws_ami" "amazon_ecs_ami" {
  most_recent = true

  # filter {
  #   name   = "owner-alias"
  #   values = ["amazon"]
  # }

  owners = ["amazon"]
  # name_regex = ".+-amazon-ecs-optimized$"
  name_regex = "amzn2-ami-ecs-hvm-.+-x86_64-ebs$"
}

module "container_service_cluster" {
  source = "github.com/azavea/terraform-aws-ecs-cluster?ref=2.0.0"

  vpc_id               = "${var.vpc_id}"
  ami_id               = "${data.aws_ami.amazon_ecs_ami.id}"
  instance_type        = "c5.2xlarge"
  key_name             = "${var.key_name}"
  cloud_config_content = "${data.template_file.container_instance_cloud_config.rendered}"

  root_block_device_type = "gp2"
  root_block_device_size = "30"

  health_check_grace_period = "600"
  desired_capacity          = "3"
  min_size                  = "3"
  max_size                  = "6"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  high_memory_threshold_percent = 75
  high_cpu_threshold_percent    = 90
  low_memory_threshold_percent  = 50

  private_subnet_ids = "${var.private_subnet_ids}"

  project     = "${var.project_name}"
  environment = "${var.environment}"
}
