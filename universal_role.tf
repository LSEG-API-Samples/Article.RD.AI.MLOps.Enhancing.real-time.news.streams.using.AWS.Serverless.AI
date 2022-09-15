resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
    role = aws_iam_role.nlp_application_role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker_execution_policy" {
    role = aws_iam_role.nlp_application_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "kinesis_execution_policy" {
    role = aws_iam_role.nlp_application_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamo_db_policy" {
    role = aws_iam_role.nlp_application_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role" "nlp_application_role" {
    name = "my_nlp_lambda_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}