
resource "aws_security_group" "application_sg" {
  vpc_id = var.vpc_id

  name        = "application-sg"
  description = "Security group for application EC2 instance"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    //cidr_blocks = ["0.0.0.0/0"] // Only form internal CIDRs
  }

  ingress {
    description     = "Allow HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.load_balancer_sg_id]
  }

  ingress {
    description     = "Allow HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.load_balancer_sg_id]
  }

#   ingress {
#     description     = "Allow application traffic"
#     from_port       = 8080 # Change this to your application's port
#     to_port         = 8080
#     protocol        = "tcp"
#     security_groups = [var.load_balancer_sg_id]
#   }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "application-sg"
  }
}