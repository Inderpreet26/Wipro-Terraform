output "vpc_id" {
  value = aws_vpc.inder-vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.inder-pub-sb.id
}

output "private_subnet_id" {
  value = aws_subnet.inder-pvt-sb.id
}

output "igw_id" {
  value = aws_internet_gateway.inder-igw.id
}