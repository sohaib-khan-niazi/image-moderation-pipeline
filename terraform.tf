terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source = "hashicorp/aws"  
      required_version = "~> 5.50"
    }
  }
}
