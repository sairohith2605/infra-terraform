data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_key_pair" "demo-instance-keypair" {
  key_name   = var.access_key_name
  public_key = var.keypair_public_key
}

resource "aws_instance" "demo-instance" {
  ami                         = data.aws_ami.amzn-linux-2023-ami.id
  instance_type               = "t2.small"
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.demo-instance-keypair.key_name
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [var.security_group_id]
  root_block_device {
    encrypted = true
  }

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
