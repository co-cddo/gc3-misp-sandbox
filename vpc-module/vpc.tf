resource "aws_vpc" "misp-fg" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "misp-fg-subnet1" {
  vpc_id            = aws_vpc.misp-fg.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "misp-fg-subnet2" {
  vpc_id            = aws_vpc.misp-fg.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_internet_gateway" "misp-fg-igw" {
  vpc_id = aws_vpc.misp-fg.id
}

resource "aws_route_table" "misp-fg-rt" {
  vpc_id = aws_vpc.misp-fg.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.misp-fg-igw.id
  }
}

resource "aws_route_table_association" "misp-fg-a" {
  subnet_id      = aws_subnet.misp-fg-subnet1.id
  route_table_id = aws_route_table.misp-fg-rt.id
}

resource "aws_route_table_association" "misp-fg-b" {
  subnet_id      = aws_subnet.misp-fg-subnet2.id
  route_table_id = aws_route_table.misp-fg-rt.id
}

resource "aws_security_group" "misp-fg-sg" {
  vpc_id = aws_vpc.misp-fg.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
