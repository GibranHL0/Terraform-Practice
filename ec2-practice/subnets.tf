resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.red_hat_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "assignment-devops"
  }
}

resource "aws_route_table" "route_table_1" {
  vpc_id = aws_vpc.red_hat_vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.red_hat_ig.id
  }

  tags = {
      Name = "test-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table_1.id
}