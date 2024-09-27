provider "aws" {
  region = "ap-south-1"
}

# Setup a VPC for the EC2 instance
resource "aws_vpc" "demo-vpc-01" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

# Declare subnets within the VPC to place
# the EC2 instance in
resource "aws_subnet" "demo-subnet" {
  vpc_id            = aws_vpc.demo-vpc-01.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.demo-vpc-01.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.demo-vpc-01.main_route_table_id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.gateway.id
}
