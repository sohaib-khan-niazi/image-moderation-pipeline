output "lambda_function_name" { 
  value = aws_lambda_function.image_moderation.function_name 
}

output "lambda_function_arn" { 
  value = aws_lambda_function.image_moderation.arn 
}
