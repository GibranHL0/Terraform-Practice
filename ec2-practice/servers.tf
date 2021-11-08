resource "aws_instance" "test_instance" {
  ami           = "ami-0ba62214afa52bec7"
  instance_type = "t2.micro"
  key_name = "my-first-server"
  security_groups = [ "${aws_security_group.test_security_group.id}" ]
  subnet_id = aws_subnet.test_subnet.id

  tags = {
      Name = "Red Hat AMI"
  }
}