resource "aws_network_interface" "multi-ip" {
  subnet_id   = aws_subnet.public_Subnet.id
}


resource "aws_eip" "nat" {
      network_interface         = aws_network_interface.multi-ip.id

}


resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_Subnet.id

  tags = {
    Name = "gw NAT"
  }
}


resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "SNAT_route"
  }
}

resource "aws_route_table_association" "b_private" {
   count=length(var.private_subnet_cidr)

  subnet_id      = aws_subnet.private_Subnet[count.index].id
  route_table_id = aws_route_table.nat_route_table.id
}

