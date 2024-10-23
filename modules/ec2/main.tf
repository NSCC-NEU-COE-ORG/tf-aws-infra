resource "aws_instance" "web_app" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [var.security_group_id] # Attach security group
  subnet_id                   = var.public_subnets[0]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 25
    delete_on_termination = true
  }

  disable_api_termination = false

  user_data = <<-EOF
    #!/bin/bash
    echo "DB_URL=jdbc:mysql://${var.rds_endpoint}/healthzdb?createDatabaseIfNotExist=true" >> /etc/environment
    echo "DB_NAME=csye6225" >> /etc/environment
    echo "DB_USERNAME=csye6225" >> /etc/environment
    echo "DB_PASSWORD=${var.database_password}" >> /etc/environment
    # Source the environment file to ensure the values are loaded
    source /etc/environment
    # Restart the application service (assuming it runs as a service)
    systemctl restart myapp.service
  EOF

  tags = {
    Name = "web-app-instance"
  }
}
