variable "instance_name" {
  type = string
  nullable = false
}

variable "environment" {
  type = string
  default = "dev"
}

variable "subnet_id" {
  type = string
}

variable "access_key_name" {
  type = string
}

variable "security_group_id" {
  type = string
}
