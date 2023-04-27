output "vpc_id" {
  value = aws_vpc.three_tier_vpc.id
}
output "rds_sg" {
  value = aws_security_group.private_rds_sg.id
}

output "lb_sg" {
  value = aws_security_group.three_tier_lb_sg.id
}

output "public_subnet_1" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2" {
  value = aws_subnet.public_subnet_2.id
}

output "private_subnet_1" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2" {
  value = aws_subnet.private_subnet_2.id
}
