variable "project" {
  type = string
  description = "Project slug"  
}

variable "environment" {
  type = string
  description = "Environment name (e.g., dev)"
}

variable "region" {
    type = string
    description = "AWS region for the env"
}

variable "extra_tags" {
    type = map(string)
    description = "Additional tags to merge into locals.tags"
    default = {}
}
