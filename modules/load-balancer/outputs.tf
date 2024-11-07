output "web_app_target_group_arn" {
  value       = aws_lb_target_group.web_app_target_group.arn
  description = "The ARN of the target group for the web application"
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.web_app_lb.dns_name
}

output "lb_zone_id" {
  description = "The Zone ID of the load balancer"
  value       = aws_lb.web_app_lb.zone_id
}