resource "aws_lambda_function" "email_sender_lambda" {
  function_name = "email-sender-lambda"
  runtime       = "java21"
  handler       = "com.emailverification.LambdaHandler::handleRequest"
  role          = aws_iam_role.lambda_execution_role.arn
  s3_bucket     = var.s3_bucket_lambda_function
  s3_key        = var.lambda_jar_key
  timeout       = 30

  environment {
    variables = {
      SECRET_NAME = "email-service-credentials"
      REGION      = var.aws_region
    }
  }

  tags = {
    Name = "email-sender-lambda"
  }
}

variable "sns_topic_arn" {
  default = "arn:aws:sns:us-east-1:123456789012:email-notification-topic"
}

resource "aws_lambda_permission" "sns_invoke_lambda" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_sender_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

resource "aws_sns_topic_subscription" "email_lambda_subscription" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.email_sender_lambda.arn
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name = "lambda-execution-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}