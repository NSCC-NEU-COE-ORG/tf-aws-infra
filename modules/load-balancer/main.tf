# Create the Application Load Balancer
resource "aws_lb" "web_app_lb" {
  name                       = "web-app-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.security_group_id]
  subnets                    = var.public_subnets
  enable_deletion_protection = false

  access_logs {
    bucket = var.s3_bucket_id # Specify the S3 bucket for access logs
  }

  enable_cross_zone_load_balancing = true

  tags = {
    Name = "WebAppLoadBalancer"
  }
}


# Create Target Group for the Load Balancer to forward traffic
resource "aws_lb_target_group" "web_app_target_group" {
  name     = "web-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 120
    path                = "/healthz" # You can specify your application's health check endpoint here
    timeout             = 10
    healthy_threshold   = 10
    unhealthy_threshold = 10
    protocol            = "HTTP"
  }

  tags = {
    Name = "WebAppTargetGroup"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_target_group.arn
  }
}
