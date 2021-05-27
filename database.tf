resource "aws_security_group" "database" {
  name        = "allow_databse"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
  
    ingress {
    description = "MYSQL Port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private_Subnet[0].id, aws_subnet.private_Subnet[1].id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "mysql_db" {
  db_subnet_group_name = aws_db_subnet_group.default.id
  allocated_storage    = 100
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "redhat"
  password             = "redhat123"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.database.id]



  provisioner "local-exec" {
  command = "echo ${aws_db_instance.mysql_db.endpoint} > DB_host.txt"
    }

}

