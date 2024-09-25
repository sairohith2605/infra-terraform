variable "sg_name" {
  type = string
  nullable = false
}

variable "description" {
  type = string
  default = "Allow inbound traffic"
}

variable "vpc_id" {
  type = string
  nullable = false
}

variable "egress_from_port" {
  type = number
}

variable "egress_to_port" {
  type = number
}

variable "egress_protocol" {
  type = string
  default = "-1"
}

variable "egress_cidr_blocks" {
  type = set(string)
  default = [ "0.0.0.0/0" ]
}

variable "ingress_from_port" {
  type = number
}

variable "ingress_to_port" {
  type = number
}

variable "ingress_protocol" {
  type = string
  default = "tcp"
}

variable "ingress_cidr_blocks" {
  type = set(string)
  default = [ "0.0.0.0/0" ]
}
