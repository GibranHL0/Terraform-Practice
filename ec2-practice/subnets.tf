resource "aws_subnet" "test_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "148.2.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "assignment-devops"
  }
}

resource "aws_route_table" "test_route_table" {
  vpc_id = aws_vpc.test_vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.test_internet_gateway.id
  }

  tags = {
      Name = "test-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_route_table.id
}