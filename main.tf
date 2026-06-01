resource "aws_vpc" "inder-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "inder-vpc"
  }
}

resource "aws_internet_gateway" "inder-igw" {
  vpc_id = aws_vpc.inder-vpc.id

  tags = {
    Name = "inder-igw"
  }
}

resource "aws_subnet" "inder-pub-sb" {
  vpc_id                  = aws_vpc.inder-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "inder-pub-sb"
  }
}

resource "aws_subnet" "inder-pvt-sb" {
  vpc_id            = aws_vpc.inder-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "inder-pvt-sb"
  }
}

resource "aws_route_table" "inder-pub-rt" {
  vpc_id = aws_vpc.inder-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inder-igw.id
  }

  tags = {
    Name = "inder-pub-rt"
  }
}

resource "aws_route_table_association" "inder-pub-rt-assoc" {
  subnet_id      = aws_subnet.inder-pub-sb.id
  route_table_id = aws_route_table.inder-pub-rt.id
}