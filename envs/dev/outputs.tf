output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  value = module.dynamodb.table_arn
}

output "lambda_role_arn" {
  value = module.iam.lambda_role_arn  
}

output "iam_policy_arn" {
  value = module.iam.policy_arn
}

output "s3_input_bucket" { 
  value = module.s3.input_bucket_id 
}
