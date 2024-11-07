output "load_balancer_sg_id" {
  description = "The Security Group ID for the Load Balancer"
  value       = aws_security_group.load_balancer_sg.id
}
