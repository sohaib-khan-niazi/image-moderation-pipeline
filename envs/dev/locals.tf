locals {
  app_prefix = "${var.project}-${var.environment}"
  
  tags = {
    Project     = "image-moderation-pipeline"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
