provider "aws" {
  region = "ap-south-1"
}

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
  availability_zone = "ap-south-1a"

  tags = {
    Name = "srr-tf-demo-subnet"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.demo-vpc-01.id

  tags = {
    Name = "internet-gateway-for-demo-vpc-01"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.demo-vpc-01.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

data "aws_availability_zones" "available" {}


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

resource "aws_key_pair" "demo-instance-keypair" {
  key_name   = "demo-instance-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfbcUu+oAvtj4yu77xYSUIk+2kxVfOpXOosLBgYOc5ZOz7KJFImDElyRuql6Pvi9pFgNEIDfcCLqHkHnh/UV2zMeDbjwzRGOgM2MsKADdWKw03HseZkD2MywG40Mh8pelzYiYducqkpCK4LnSpqLbtTcko2A4rzrIuiojyu3HsdoQLBPC/FBQECq6MauQ6/eeonk4Xn9t9hCvbFVmNUFeRNl2ypvPbAdOwCf6UrikDJImRsUYJk+jpbN51ZCVash8XeWoQm3HhENDzK6IUuk8mTJR1uJRvWOoXpck12Ae2qAw1nc9YR5Grk+/6wbp3XTE6ep1OUFfPezhuQoA2Ze+FThOuvJClIf6S+ZajTFETDywgFFnjvndXGS8vlKvQDZXiS2bmx/Xf3bCb3SiX6imtF3MsJxu2s2cKrQdjwQUWakQRxAGvq083MLm0QfFx+8ncF20IxSZm0zw57ENbbZV9ZFugztT9Fuw9oVujRHCDwiV0LYkzi2vSZ1eMKGvKg+s= sairohith@DESKTOP-M4L9POK"
}

resource "aws_security_group" "demo-instance-sg" {
  name        = "demo-instance-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.demo-vpc-01.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["183.82.109.207/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Provision the EC2 instance of type t2.small
# within the subnet created above, and the ami
# filtered by the data block
resource "aws_instance" "demo-instance" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.small"
  subnet_id     = aws_subnet.demo-subnet.id
  key_name = aws_key_pair.demo-instance-keypair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.demo-instance-sg.id]

  tags = {
    Name = "srr-tf-demo-ec2"
    Environment = "Demo"
  }

  
}

# Output the public DNS of the instance
output "instance_public_dns" {
  value = aws_instance.demo-instance.public_dns
}

