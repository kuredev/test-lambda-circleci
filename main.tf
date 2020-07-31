provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_lambda_function" "test-terraform" {
  filename         = data.archive_file.test-terraform.output_path
  function_name    = "test-terraform" #
  role             = aws_iam_role.test-terraform.arn #
  handler          = "lambda_handler.LambdaHandler.lambda_handler" #
  runtime          = "ruby2.7" #
  source_code_hash = data.archive_file.test-terraform.output_base64sha256
}

data "archive_file" "test-terraform" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "tmp/test-terraform.zip"
}

data "aws_iam_policy_document" "test-terraform" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "test-terraform" {
  name               = "test-terraform-role"
  assume_role_policy = data.aws_iam_policy_document.test-terraform.json
}

resource "aws_iam_role_policy_attachment" "test-terraform" {
  role       = aws_iam_role.test-terraform.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
