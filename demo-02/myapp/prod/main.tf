provider "aws" {
  region = "ap-southeast-1"
}

module "main" {
  source        = "../../modules/tf-asg"
  ami_id        = "${var.ami_id}"
  service_name  = "${var.service_name}"
  service_env   = "${var.service_env}"
  vpc_id        = "${var.vpc_id}"
  key_name      = "${var.key_name}"
  subnets       = "${var.subnets}"
  allowed_cidrs = "${var.allowed_cidrs}"
  service_sg    = "${aws_security_group.main.id}"
}
