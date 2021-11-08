provider "aws" {
  region = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

# 1. Create VPC
resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "production"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    "Name" = "Prod Gateway"
  }
}

# 3. Create Custom Route Table
resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    "Name" = "production_route_table"
  }
}

# 4. Create Subnet
resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.prod_vpc.id
  availability_zone = "us-east-2a"
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "prod-subnet"
  }
}

# 5. Associate subnet with route table
resource "aws_route_table_association" "route_association" {
  route_table_id = aws_route_table.prod_route_table.id
  subnet_id = aws_subnet.subnet_1.id
}

# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id = aws_vpc.prod_vpc.id

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
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# 7. Create a network interface with an ip in the subnet
resource "aws_network_interface" "web_server_nic" {
  subnet_id = aws_subnet.subnet_1.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

# 8. Assign an elastic IP to the network interface
resource "aws_eip" "one" {
  vpc = true
  network_interface = aws_network_interface.web_server_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.gw
  ]
}

# 9. Create Ubuntu server and install/enable apache2
resource "aws_instance" "web_server_instance" {
  ami = "ami-020db2c14939a8efb"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = "my-first-server"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web_server_nic.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install apache2 -v
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html
                EOF

  tags = {
    Name = "ubuntu"
  }
}
