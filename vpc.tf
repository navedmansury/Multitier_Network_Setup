resource "aws_vpc" "main" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}
resource "aws_subnet" "private_Subnet" {
  count=length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidr,count.index)
  availability_zone =element(var.azs,count.index)
  tags = {
    Name = element(var.private_subnet_name,count.index)
  }
}

resource "aws_subnet" "public_Subnet" {
  availability_zone = "ap-south-1b"
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.2.2.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_Subnet.id
  route_table_id = aws_route_table.route_table.id
}
