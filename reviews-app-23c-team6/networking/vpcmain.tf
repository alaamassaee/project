# CREATE VPC AND SUBNETS
resource "aws_vpc" "app_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.name_tag}_vpc"
  }
}

resource "aws_subnet" "public_app_subnet_1" {
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.pubsubnet1_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_tag}_public_subnet1"
  }
}

resource "aws_subnet" "public_app_subnet_2" {
  availability_zone       = "us-east-1b"
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.pubsubnet2_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_tag}_public_subnet2"
  }
}

resource "aws_subnet" "private_app_subnet_1" {
  availability_zone       = "us-east-1c"
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.privsubnet1_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name_tag}_private_subnet1"
  }
}

resource "aws_subnet" "private_app_subnet_2" {
  availability_zone       = "us-east-1d"
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.privsubnet2_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name_tag}_private_subnet2"
  }
}

# CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.name_tag}_igw"
  }
}

# CREATE PUBLIC ROUTE TABLE
resource "aws_route_table" "public_app_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = "${var.name_tag}_pubrt"
  }
}

# CREATE PRIVATE ROUTE TABLE
resource "aws_route_table" "private_app_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route = []

  tags = {
    Name = "${var.name_tag}_privrt"
  }
}

# CREATE PUBLIC AND PRIVATE SUBNET ASSOCIATION
resource "aws_route_table_association" "pubsub1_ass" {
  subnet_id      = aws_subnet.public_app_subnet_1.id
  route_table_id = aws_route_table.public_app_rt.id
}

resource "aws_route_table_association" "pubsub2_ass" {
  subnet_id      = aws_subnet.public_app_subnet_2.id
  route_table_id = aws_route_table.public_app_rt.id
}

resource "aws_route_table_association" "privsub1_ass" {
  subnet_id      = aws_subnet.private_app_subnet_1.id
  route_table_id = aws_route_table.private_app_rt.id
}

resource "aws_route_table_association" "privsub2_ass" {
  subnet_id      = aws_subnet.private_app_subnet_2.id
  route_table_id = aws_route_table.private_app_rt.id
}

# CREATE SECURITY GROUP FOR VPC
resource "aws_security_group" "app-vpc-sg" {
  name        = "${var.name_tag}_sg"
  vpc_id      = aws_vpc.app_vpc.id
  description = "mini-project-vpc-sg"

  dynamic "ingress" {
    for_each = [22, 80, 443]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
