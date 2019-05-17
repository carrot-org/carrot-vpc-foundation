resource "aws_lb" "jenkins" {
  name               = "jenkins-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_access.id}"]
  subnets            = ["${var.vpc_public_subnets}"]

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "jenkins-web" {
  load_balancer_arn = "${aws_lb.jenkins.arn}"
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.jenkins.arn}"
  }
}

resource "aws_lb_target_group" "jenkins" {
  lifecycle {
    create_before_destroy = true
  }

  name     = "tf-jenkins-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  # target_type = "instance"            # "instance" for bridge network
  target_type = "ip" # "ip" for awsvpc network

  health_check {
    interval = 60
    timeout  = 30
    path     = "/login"
    port     = 8080
    matcher  = "200"
  }
}
