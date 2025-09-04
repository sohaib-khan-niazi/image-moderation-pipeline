# Lambda module

module "lambda" {
  source              = "../../modules/lambda"
  role_arn            = module.iam.lambda_role_arn
  function_name       = "${local.app_prefix}-image-moderation-lambda"
  dynamodb_table_arn  = module.dynamodb.table_arn
  s3_bucket_arn       = module.s3.input_bucket_arn
}

# DynamoDB module

module "dynamodb" {
    source = "../../modules/dynamodb"
    table_name = "${local.app_prefix}-results"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "image_id"
    tags = local.tags
}

# IAM module

module "iam" {
  source = "../../modules/iam"
  role_name = "${local.app_prefix}-lambda-role"
  tags = local.tags
  dynamodb_table_arn = module.dynamodb.table_arn
  input_bucket_name = "${local.app_prefix}-input"  
}

# S3 module

module "s3" {
  source            = "../../modules/s3"
  input_bucket_name = "${local.app_prefix}-input"
  enable_versioning = false
  lambda_function_arn = module.lambda.lambda_function_arn
  tags = local.tags
}

# Allow S3 to invoke Lambda
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  # Use the lambda ARN or name output from your lambda module
  function_name = module.lambda.lambda_function_arn
  # Use the bucket ARN output from your s3 module
  source_arn    = module.s3.input_bucket_arn
}

# Attach notification to the bucket to invoke Lambda on object created
resource "aws_s3_bucket_notification" "invoke_lambda_on_put" {
  bucket = module.s3.input_bucket_id  

  lambda_function {
    lambda_function_arn = module.lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}
