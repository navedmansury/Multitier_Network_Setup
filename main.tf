
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
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




resource "aws_instance" "web" {
  ami           = "ami-010aff33ed5991201"
  instance_type = "t2.micro"
  availability_zone="ap-south-1b"
  subnet_id = aws_subnet.public_Subnet.id
  security_groups = [aws_security_group.allow_tls.id]
  key_name = "task1-key"
  tags = {
    Name = "MY WEB"
  }
  
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./task1-key.pem")
    host     = aws_instance.web.public_ip
  }
  


  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd php git -y",
      "sudo systemctl start httpd",
      "sudo amazon-linux-extras install php7.3 -y",
      "sudo wget https://wordpress.org/latest.tar.gz",
      "sudo tar -zxf latest.tar.gz",
      "sudo cp -r wordpress/* /var/www/html/",
      "sudo chmod -R 755 wp-content",
     "sudo wget https://s3.amazonaws.com/bucketforwordpresslab-donotdelete/htaccess.txt",
     " sudo mv htaccess.txt /var/www/html/.htaccess",
      "sudo systemctl restart httpd",
       "sudo systemctl enable httpd",
    ]
  }

  provisioner "local-exec" {
  command = "echo ${aws_instance.web.public_ip} > host_public_ip.txt"
    }



}