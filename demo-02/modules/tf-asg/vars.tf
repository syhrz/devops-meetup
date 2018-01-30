variable "byte_length" {
  default = 5
}

variable "service_name" {}

variable "service_env" {}

variable "service_sg" {}

variable "vpc_id" {}

variable "key_name" {}

variable "instance_type" {
  default = "t2.nano"
}

variable "health_check_port" {
  default = 80
}

variable "health_check_path" {
  default = "/"
}

variable "deregistration_delay" {
  default = 60
}

variable "availability_zones" {
  default     = "ap-southeast-1a,ap-southeast-1b,ap-southeast-1c"
  description = "Avaibility zone of the resources"
}

variable "asg_max" {
  default = 1
}

variable "asg_min" {
  default = 1
}

variable "asg_desired" {
  default = 1
}

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "subnets" {
  type = "list"
}

variable "ami_id" {}

variable "allowed_cidrs" {
  type = "list"
}
