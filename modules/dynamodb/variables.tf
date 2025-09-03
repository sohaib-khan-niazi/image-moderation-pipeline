variable "table_name" {
  type = string  
}

variable "billing_mode" {
  type = string
  default = "PAY_PER_REQUEST"
}

variable "hash_key" {
  type = string
  default = "image_id"  
}

variable "server_side_kms_arn" {
  type = string
  default = "null"  
}

variable "tags" {
  type = map(string)
  default = {}  
}
