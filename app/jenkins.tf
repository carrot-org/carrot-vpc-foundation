# Review: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
resource "aws_ecs_task_definition" "jenkins-task" {
  family = "${var.cluster_name}-jenkins"

  execution_role_arn = "${aws_iam_role.ecs_exec.arn}"
  task_role_arn      = "${aws_iam_role.ecs_task.arn}"

  network_mode = "awsvpc"

  container_definitions = "${file("app/task-definitions/jenkins.json")}"

  volume {
    name      = "dockersock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "blue"
    host_path = "/mnt/efs/jenkins/blue-1/"
  }
}

resource "aws_ecs_service" "jenkins" {
  name            = "${var.environment}-jenkins"
  cluster         = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.jenkins-task.arn}"
  desired_count   = 1

  health_check_grace_period_seconds = 60

  load_balancer {
    target_group_arn = "${aws_lb_target_group.jenkins.arn}"
    container_name   = "jenkins"
    container_port   = 8080
  }

  network_configuration {
    subnets         = ["${var.vpc_private_subnets}"]
    security_groups = ["${var.ecs_cluster_security_group_id}"] # TODO, use custom SG
  }

  service_registries = {
    registry_arn   = "${aws_service_discovery_service.ecs-dev.arn}"
    container_port = "50000"
    container_name = "jenkins"
  }
}

resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name        = "ecs"
  description = "ECS Service Discovery"
  vpc         = "${var.vpc_id}"
}

resource "aws_service_discovery_service" "ecs-dev" {
  name = "jenkins"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.ecs.id}"

    dns_records = [{
      ttl  = 1
      type = "SRV"
    },
      {
        ttl  = 1
        type = "A"
      },
    ]

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_iam_role" "ecs_exec" {
  name               = "ecs_exec_aws_iam_role_jenkins_${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:*",
      "ecs:*",
    ]
  }
}

data "aws_iam_policy_document" "ecs_exec" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_exec" {
  name   = "ecs_exec_aws_iam_role_policy"
  policy = "${data.aws_iam_policy_document.ecs_exec.json}"
  role   = "${aws_iam_role.ecs_exec.id}"
}

resource "aws_iam_role_policy" "ecs_task" {
  name   = "ecs_exec_aws_iam_role_policy"
  policy = "${data.aws_iam_policy_document.ecs_task.json}"
  role   = "${aws_iam_role.ecs_task.id}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "ecs_task_aws_iam_role_${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}
