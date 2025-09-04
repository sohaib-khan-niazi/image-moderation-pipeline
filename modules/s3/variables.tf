variable "input_bucket_name" { 
  type = string 
}

variable "enable_versioning" { 
  type = bool
  default = false 
}

variable "block_public" { 
  type = bool   
  default = true 
}

variable "force_ssl" { 
  type = bool   
  default = true 
}

variable "lambda_function_arn" {
  type = string  
}

variable "tags" { 
  type = map(string) 
  default = {} 
}

