resource "aws_dynamodb_table" "this" {
  name = var.table_name
  billing_mode = var.billing_mode
  hash_key = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  server_side_encryption {
    enabled = true
    kms_key_arn = var.server_side_kms_arn
  }

  tags = var.tags
}
