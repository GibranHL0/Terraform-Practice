resource "aws_instance" "red_hat_server" {
  ami           = "ami-0ba62214afa52bec7"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = "my-first-server"
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.red_hat_nic.id
  }

  tags = {
      Name = "Red Hat AMI"
  }
}