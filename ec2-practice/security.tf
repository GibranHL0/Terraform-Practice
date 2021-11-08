resource "aws_security_group" "test_security_group" {
  vpc_id = aws_vpc.test_vpc.id
  name = "allow-all-sg"

  ingress {
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"
      ]
      from_port = 22
      to_port = 22
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}