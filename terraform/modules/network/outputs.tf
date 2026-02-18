output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id 
}

output "subnet_id" {
  value = aws_subnet.public[0].id 
}
