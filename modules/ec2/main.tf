resource "aws_iam_role" "cloudwatch_role" {
  name = "ec2-cloudwatch-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "cloudwatch-logs-metrics-policy"
  description = "Policy for CloudWatch logs, metrics, and S3 access"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutRetentionPolicy",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "*",
        ]
      }
    ]
  })
}

# Attach the IAM Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

# Instance Profile for attaching IAM Role to EC2
resource "aws_iam_instance_profile" "cloudwatch_profile" {
  name = "cloudwatch-instance-profile"
  role = aws_iam_role.cloudwatch_role.name
}

# EC2 Instance configuration
resource "aws_instance" "web_app" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  vpc_security_group_ids = [var.security_group_id]
  subnet_id                   = var.public_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.cloudwatch_profile.name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 25
    delete_on_termination = true
  }

  disable_api_termination = false

  # User data script for configuring environment variables and restarting services
  user_data = <<-EOF
    #!/bin/bash
    echo "DB_URL=jdbc:mysql://${var.rds_endpoint}/healthzdb?createDatabaseIfNotExist=true" >> /etc/environment
    echo "DB_NAME=csye6225" >> /etc/environment
    echo "DB_USERNAME=csye6225" >> /etc/environment
    echo "DB_PASSWORD=${var.database_password}" >> /etc/environment
    echo "AWS_S3_BUCKET=${var.s3_bucket_id}" >> /etc/environment
    echo "AWS_DEFAULT_REGION=${var.aws_region}" >> /etc/environment
    source /etc/environment
    # Restart cloudwatch agent to pick up new configs
    systemctl restart amazon-cloudwatch-agent
    # Restart application service if needed
    if systemctl is-enabled myapp.service; then
      systemctl restart myapp.service
    fi
  EOF

  tags = {
    Name = "web-app-instance"
  }
}

# Output the Public IP of the Instance for Route 53 setup
output "web_app_public_ip" {
  description = "Public IP address of the web application instance"
  value       = aws_instance.web_app.public_ip
}