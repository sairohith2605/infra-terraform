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
  nullable = false
}

variable "access_key_name" {
  type = string
}

variable "security_group_id" {
  type = string
  nullable = false
}

variable "associate_public_ip_address" {
  type = bool
  default = false
}

variable "keypair_public_key" {
  type = string
}
