provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "main" {
  name        = "allow_from_w77-3"
  description = "Allow SSh and HTTP from Wisma 77"
  vpc_id      = "vpc-f8c91a9f"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.allowed_cidrs}"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "${var.allowed_cidrs}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {}
}

resource "aws_instance" "instance" {
  count           = 2
  ami             = "ami-325d2e4e"
  instance_type   = "t2.nano"
  key_name        = "dev"
  security_groups = ["${aws_security_group.main.name}"]

  tags {
    Name              = "Hello World"
    Terraform_managed = "True"
  }
}
