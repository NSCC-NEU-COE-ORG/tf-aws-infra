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
  description = "Policy for CloudWatch logs and metrics"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

resource "aws_iam_instance_profile" "cloudwatch_profile" {
  name = "cloudwatch-instance-profile"
  role = aws_iam_role.cloudwatch_role.name
}

resource "aws_instance" "web_app" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  vpc_security_group_ids = [var.security_group_id] # Attach security group
  subnet_id                   = var.public_subnets[0]
  associate_public_ip_address = true
  s3_bucket_id                = var.s3_bucket_id
  aws_region                  = var.aws_region
  iam_instance_profile        = aws_iam_instance_profile.cloudwatch_profile.name

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
    echo "AWS_S3_BUCKET=${var.s3_bucket_id}" >> /etc/environment
    echo "AWS_DEFAULT_REGION=${var.aws_region}" >> /etc/environment
    # Source the environment file to ensure the values are loaded
    source /etc/environment
    # Restart the application service (assuming it runs as a service)
    sudo systemctl restart amazon-cloudwatch-agent
    systemctl restart myapp.service
  EOF

  tags = {
    Name = "web-app-instance"
  }
}
