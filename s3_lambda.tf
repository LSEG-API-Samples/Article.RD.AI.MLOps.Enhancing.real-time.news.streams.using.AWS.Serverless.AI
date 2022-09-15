data "archive_file" "lambda_triggering_sagemaker" {
  type = "zip"

  source_dir  = ""
  output_path = ""
}

data "archive_file" "lambda_to_rabitmq" {
  type = "zip"

  source_dir  = ""
  output_path = ""
}

resource "aws_s3_bucket" "my_nlp_bucket" {
  bucket = "my-nlp-bucket"
}

resource "aws_s3_bucket_acl" "nlp_bucket_acl" {
  bucket = aws_s3_bucket.my_nlp_bucket.bucket
  acl    = "private"
}

resource "aws_s3_object" "lambda_triggering_sagemaker" {
  bucket = aws_s3_bucket.my_nlp_bucket.id
  key    = "sagemaker_lambda.zip"
  source = data.archive_file.lambda_triggering_sagemaker.output_path
  etag   = filemd5(data.archive_file.lambda_triggering_sagemaker.output_path)
}

resource "aws_s3_object" "lambda_to_rabitmq" {
  bucket = aws_s3_bucket.my_nlp_bucket.id
  key    = "rabitmq_lambda.zip"
  source = data.archive_file.lambda_to_rabitmq.output_path
  etag   = filemd5(data.archive_file.lambda_to_rabitmq.output_path)
}
