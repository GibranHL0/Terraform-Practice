resource "aws_vpc" "red_hat_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "VPC Red Hat Instances"
  }
}

resource "aws_network_interface" "red_hat_nic" {
  subnet_id = aws_subnet.subnet_1.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_ssh.id]
}

resource "aws_eip" "red_hat_eip" {
  vpc = true
  network_interface = aws_network_interface.red_hat_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.red_hat_ig
  ]
}