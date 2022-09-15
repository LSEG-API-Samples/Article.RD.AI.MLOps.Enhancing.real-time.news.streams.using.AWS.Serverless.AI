resource "aws_lambda_function" "my_nlp_lambda_function" {
  function_name = "NLPLambda"

  s3_bucket = aws_s3_bucket.my_nlp_bucket.bucket
  s3_key    = aws_s3_object.lambda_triggering_sagemaker.key

  runtime = "python3.7"
  handler = "lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda_triggering_sagemaker.output_base64sha256

  role = aws_iam_role.nlp_application_role.arn

}

resource "aws_lambda_function" "my_rabitmq_lambda_function" {
  function_name = "RabitMQLambda"

  s3_bucket = aws_s3_bucket.my_nlp_bucket.bucket
  s3_key    = aws_s3_object.lambda_to_rabitmq.key

  runtime = "python3.7"
  handler = "lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda_triggering_sagemaker.output_base64sha256
  layers = [
    resource.aws_lambda_layer_version.mqtt_layer.arn
  ]
  role = aws_iam_role.nlp_application_role.arn

  environment {
    variables = {
      RABBITMQ_USERNAME = var.rabbitmq_user
      RABBITMQ_PASSWORD = var.rabbitmq_password
      RABBITMQ_ARN      = aws_mq_broker.rabbitMQ.arn
    }
  }
}

resource "aws_lambda_event_source_mapping" "sagemaker_lambda_event_source" {
  batch_size        = 1
  event_source_arn  = aws_kinesis_stream.nlp_kinesis_stream.arn
  enabled           = true
  function_name     = aws_lambda_function.my_nlp_lambda_function.function_name
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "rabitmq_lambda_event_source" {
  batch_size        = 1
  event_source_arn  = aws_dynamodb_table.nlp_news_headlines_table.stream_arn
  enabled           = true
  function_name     = aws_lambda_function.my_rabitmq_lambda_function.function_name
  starting_position = "LATEST"
}
