provider "aws" {
  region = "ap-south-1"
}

module "vpc_ec2_demo" {
  source                = "./vpc"
  vpc_name              = "srr-tf-vpc-${var.ec2_instance_environment}"
  vpc_cidr_block        = "172.16.0.0/16"
  subnet_name           = "srr-tf-demo-subnet"
  subnet_cidr_block     = "172.16.10.0/24"
  availability_zone     = "ap-south-1a"
  internet_gateway_name = "internet-gateway-vpc-${var.ec2_instance_environment}"
}

module "security_group_ec2" {
  source            = "./securitygroups"
  sg_name           = "security-group-ec2-${var.ec2_instance_environment}"
  vpc_id            = module.vpc_ec2_demo.vpc_id
  ingress_from_port = 22
  ingress_to_port   = 22
  egress_from_port  = 0
  egress_to_port    = 0
}

module "ec2_instance_demo" {
  source            = "./ec2"
  instance_name     = "srr-tf-ec2-${var.ec2_instance_environment}"
  environment       = var.ec2_instance_environment
  access_key_name   = "ec2-access-keypair-${var.ec2_instance_environment}}"
  subnet_id         = module.vpc_ec2_demo.subnet_id
  security_group_id = module.security_group_ec2.security_group_id
  keypair_public_key = var.keypair_public_key
}

# Output the public DNS of the instance
output "instance_public_dns" {
  value = module.ec2_instance_demo.public_dns
}
