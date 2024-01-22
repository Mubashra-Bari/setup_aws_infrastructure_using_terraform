#VPC creation
resource "aws_vpc" "myVPC" {
  cidr_block = "10.0.0.0/16"
}
#Subnet creation
resource "aws_subnet" "mySubnet" {
  vpc_id = aws_vpc.myVPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet1"
  }
}
#Internet Gateway creation
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id
}
#Route table creation
resource "aws_route_table" "myRoute" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id   = aws_internet_gateway.myIGW.id
  }
  tags = {
    Name = "Route1"
  }
}
#Subnet Association with Route table
resource "aws_route_table_association" "Subnetassociate" {
  subnet_id = aws_subnet.mySubnet.id
  route_table_id = aws_route_table.myRoute.id
}
#Security Group creation
resource "aws_security_group" "mySG" {
  name = "allow web traffic"
  description = "allowing inbound traffic"
  vpc_id = aws_vpc.myVPC.id

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "SSH"
    from_port = 20
    to_port = 20
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#Network inteface creation
resource "aws_network_interface" "myNI" {
  subnet_id = aws_subnet.mySubnet.id
  security_groups = [aws_security_group.mySG.id]
  private_ip = "10.0.1.50"
}
#Elastic IP creation
resource "aws_eip" "myeip" {
  network_interface = aws_network_interface.myNI.id
  #associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.myIGW]
  domain = "vpc"
}
#Instance
resource "aws_instance" "myServer" {
  ami = "ami-0e9107ed11be76fde"
  availability_zone = "us-east-1a"
  instance_type =  "t3.micro"
  key_name = "momo"
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.myNI.id
  }
  #User data block
  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install httpd -y
            sudo service httpd start
            sudo bash -c "echo Hi there, its Mubashra welcome to my webserver > /var/www/html/index.html"
            EOF
    tags = {
    Name = "linux-server"
}

}


