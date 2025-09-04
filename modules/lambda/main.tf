resource "aws_lambda_function" "image_moderation" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 60
  memory_size   = 128

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_arn
    }
  }

  # Lambda deployment package (ZIP file)
  filename = "${path.root}/../../lambda_src/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.root}/../../lambda_src/lambda_function.zip")
}
