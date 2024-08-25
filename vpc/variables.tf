variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr_block" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "internet_gateway_name" {
  type = string
}

variable "destination_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}
