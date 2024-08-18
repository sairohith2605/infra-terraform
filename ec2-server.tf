# Setup a VPC for the EC2 instance
resource "aws_vpc" "demo-vpc-01" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "srr-tf-demo-vpc-01"
  }
}

# Declare subnets within the VPC to place
# the EC2 instance in
resource "aws_subnet" "demo-subnet" {
  vpc_id            = aws_vpc.demo-vpc-01.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "srr-tf-demo-subnet"
  }
}

# Use this data block to filter out the
# AWS AMI images for the EC2 linux instance
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Provision the EC2 instance of type t2.small
# within the subnet created above, and the ami
# filtered by the data block
resource "aws_instance" "demo-instance" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.small"
  subnet_id     = aws_subnet.demo-subnet.id

  tags = {
    Name = "srr-tf-demo-ec2"
    Environment = "Demo"
  }
}
