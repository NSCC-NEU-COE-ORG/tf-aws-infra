resource "aws_instance" "web_app" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [var.security_group_id]  # Attach security group
  subnet_id                   = var.public_subnets[0]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 25
    delete_on_termination = true
  }

  disable_api_termination = false  # Do not protect against accidental termination

  tags = {
    Name = "web-app-instance"
  }
}
