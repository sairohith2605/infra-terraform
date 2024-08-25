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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfbcUu+oAvtj4yu77xYSUIk+2kxVfOpXOosLBgYOc5ZOz7KJFImDElyRuql6Pvi9pFgNEIDfcCLqHkHnh/UV2zMeDbjwzRGOgM2MsKADdWKw03HseZkD2MywG40Mh8pelzYiYducqkpCK4LnSpqLbtTcko2A4rzrIuiojyu3HsdoQLBPC/FBQECq6MauQ6/eeonk4Xn9t9hCvbFVmNUFeRNl2ypvPbAdOwCf6UrikDJImRsUYJk+jpbN51ZCVash8XeWoQm3HhENDzK6IUuk8mTJR1uJRvWOoXpck12Ae2qAw1nc9YR5Grk+/6wbp3XTE6ep1OUFfPezhuQoA2Ze+FThOuvJClIf6S+ZajTFETDywgFFnjvndXGS8vlKvQDZXiS2bmx/Xf3bCb3SiX6imtF3MsJxu2s2cKrQdjwQUWakQRxAGvq083MLm0QfFx+8ncF20IxSZm0zw57ENbbZV9ZFugztT9Fuw9oVujRHCDwiV0LYkzi2vSZ1eMKGvKg+s= sairohith@DESKTOP-M4L9POK"
}

resource "aws_instance" "demo-instance" {
  ami                         = data.aws_ami.amzn-linux-2023-ami.id
  instance_type               = "t2.small"
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.demo-instance-keypair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
