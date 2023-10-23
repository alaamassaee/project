output "vpc_id" {
  value = aws_vpc.app_vpc.id
}
output "public_subnet1_id" {
  value = aws_subnet.public_app_subnet_1.id
}
output "public_subnet2_id" {
  value = aws_subnet.public_app_subnet_2.id
}
output "private_subnet1_id" {
  value = aws_subnet.private_app_subnet_1.id
}
output "private_subnet2_id" {
  value = aws_subnet.private_app_subnet_2.id
}
