
output "instance_public_ip" {
  value = aws_instance.web_app.public_ip
}

output "instance_id" {
  value = aws_instance.web_app.id
}

