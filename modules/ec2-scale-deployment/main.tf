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
          "s3:ListBucket"
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
  name = "ccloudwatch-instance-profile"
  role = aws_iam_role.cloudwatch_role.name
}

# Launch Template
resource "aws_launch_template" "csye6225_asg_template" {
  name          = "csye6225_asg"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.security_group_id]  # Use your web app security group
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.cloudwatch_profile.name  # Use the same IAM instance profile as EC2 instance
  }

  # Encode user_data with base64encode
  user_data = base64encode( <<-EOF
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
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web_app_asg" {
  desired_capacity    = 3
  max_size            = 5
  min_size            = 3
  vpc_zone_identifier = var.public_subnets  # Subnet IDs for launching instances

  launch_template {
    id      = aws_launch_template.csye6225_asg_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-app-instance"
    propagate_at_launch = true
  }

  target_group_arns = [var.web_app_target_group_arn]
}

# CloudWatch Alarm for CPU Usage - Scale Up
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_high_usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Alarm if CPU exceeds 5%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}

# CloudWatch Alarm for CPU Usage - Scale Down
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu_low_usage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 3
  alarm_description   = "Alarm if CPU goes below 3%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]
}

# Auto Scaling Policy - Scale Up
resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

# Auto Scaling Policy - Scale Down
resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}