resource "aws_cloudwatch_log_group" "lambda_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.my_nlp_lambda_function.function_name}"
  retention_in_days = 1
}