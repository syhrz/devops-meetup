variable "service_name" {
  default = "myapp"
}

variable "service_env" {}

variable "ami_id" {}

variable "vpc_id" {
  default = "vpc-f8c91a9f"
}

variable "key_name" {}

variable "subnets" {
  type = "list"
}

variable "allowed_cidrs" {
  default = [
    "0.0.0.0/0",
  ]
}

variable "hello" {}
