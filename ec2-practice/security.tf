resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.red_hat_vpc.id
  name = "allow-all-sg"

  ingress {
      protocol = "SSH"
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