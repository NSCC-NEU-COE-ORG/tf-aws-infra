output "sns_topic_arn" {
  value       = aws_sns_topic.email_notification_topic.arn
  description = "ARN of the SNS topic for email notifications"
}