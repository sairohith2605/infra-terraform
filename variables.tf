variable "ec2_instance_environment" {
  type = string
  default = "dev"
}

variable "s3_state_bucket" {
  type = string
  nullable = false
}
