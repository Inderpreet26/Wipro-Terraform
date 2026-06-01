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

resource "aws_eip" "inder-eip" {
  domain = "vpc"

  tags = {
    Name = "inder-eip"
  }
}

resource "aws_nat_gateway" "inder-nat-gw" {
  allocation_id = aws_eip.inder-eip.id
  subnet_id     = aws_subnet.inder-pub-sb.id

  tags = {
    Name = "inder-nat-gw"
  }
}

resource "aws_key_pair" "inder-key" {
  key_name   = "inder-key"
  public_key = file("C:/Users/heyin/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "inder-sg" {
  name   = "inder-sg"
  vpc_id = aws_vpc.inder-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "inder-sg"
  }
}

resource "aws_instance" "inder-ec2" {
  ami = "ami-0543dbdaf4e114be7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.inder-pub-sb.id
  key_name               = aws_key_pair.inder-key.key_name
  vpc_security_group_ids = [aws_security_group.inder-sg.id]

  tags = {
    Name = "inder-ec2"
  }
}