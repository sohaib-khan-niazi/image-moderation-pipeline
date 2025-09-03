# DynamoDB module

module "dynamodb" {
    source = "../../modules/dynamodb"
    table_name = "${local.app_prefix}-results"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "image_id"
    server_side_kms_arn = null
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
  tags              = local.tags
}
