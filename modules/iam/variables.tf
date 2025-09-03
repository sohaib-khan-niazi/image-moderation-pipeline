variable "role_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "dynamodb_table_arn" {
  type = string
}

variable "input_bucket_name" {
    type = string
}
