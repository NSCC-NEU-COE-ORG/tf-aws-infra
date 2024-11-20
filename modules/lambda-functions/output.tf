output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.email_sender_lambda.function_name
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution_role.arn
}