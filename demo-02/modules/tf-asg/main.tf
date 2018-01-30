resource "random_id" "server" {
  keepers = {
    service_name = "${var.service_name}"
  }

  byte_length = "${var.byte_length}"
}

resource "aws_alb_target_group" "target-group" {
  name                 = "${var.service_name}${var.service_env}tg${random_id.server.id}"
  port                 = "${var.health_check_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    port    = "${var.health_check_port}"
    path    = "${var.health_check_path}"
    matcher = 200
  }
}

resource "aws_alb" "alb" {
  name                       = "${var.service_name}pvtalb${var.service_env}${random_id.server.id}"
  security_groups            = ["${aws_security_group.lb-sg.id}"]
  subnets                    = "${var.subnets}"
  enable_deletion_protection = true

  tags {
    Environment = "${var.service_env}"
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.target-group.arn}"
    type             = "forward"
  }
}

resource "aws_launch_configuration" "lc" {
  lifecycle {
    create_before_destroy = true
  }

  image_id        = "${var.ami_id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.sg.id}", "${var.service_sg}"]
  key_name        = "${var.key_name}"

  user_data = <<-EOF
                 #!/bin/bash

                 EOF
}

resource "aws_autoscaling_group" "asg" {
  lifecycle {
    create_before_destroy = true
  }

  availability_zones        = ["${split(",", var.availability_zones)}"]
  name                      = "${var.service_name}-${aws_launch_configuration.lc.name}"
  launch_configuration      = "${aws_launch_configuration.lc.name}"
  max_size                  = "${var.asg_max}"
  min_size                  = "${var.asg_min}"
  min_elb_capacity          = "${var.asg_desired}"
  desired_capacity          = "${var.asg_desired}"
  force_delete              = true
  target_group_arns         = ["${aws_alb_target_group.target-group.arn}"]
  vpc_zone_identifier       = "${var.subnets}"
  wait_for_capacity_timeout = "5m"

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

  tag {
    key                 = "Name"
    value               = "${var.service_name}-${var.service_env}-${random_id.server.id}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Cluster"
    value               = "${var.service_name}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = "${var.service_env}"
    propagate_at_launch = "true"
  }
}

resource "aws_security_group" "lb-sg" {
  name        = "${var.service_name}lbpub${var.service_env}${random_id.server.id}"
  vpc_id      = "${var.vpc_id}"
  description = "${var.service_name} ${var.service_env} lb security groups"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.service_name}${var.service_env}${random_id.server.id}"
  vpc_id      = "${var.vpc_id}"
  description = "${var.service_name} ${var.service_env} security groups"

  ingress {
    from_port       = "${var.health_check_port}"
    to_port         = "${var.health_check_port}"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb-sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Service     = "${var.service_name}"
    Cluster     = "${var.service_name}"
    Environment = "${var.service_env}"
  }
}
