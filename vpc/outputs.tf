output "vpc_id" {
  value = aws_vpc.demo-vpc-01.id
}

output "subnet_id" {
  value = aws_subnet.demo-subnet.id
}
