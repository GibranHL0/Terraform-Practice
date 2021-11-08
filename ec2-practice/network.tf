resource "aws_vpc" "test_vpc" {
  cidr_block = "148.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "assignment-devops"
  }
}

resource "aws_eip" "test-elastic-ip" {
  instance = aws_instance.test_instance.id
  vpc = true
}