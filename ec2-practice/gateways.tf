resource "aws_internet_gateway" "red_hat_ig" {
  vpc_id = aws_vpc.red_hat_vpc.id

  tags = {
      Name = "test-internet-gateway"
  }
}