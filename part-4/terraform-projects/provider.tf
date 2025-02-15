provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  backend "s3" {
    bucket         = "olymahmud-my-terraform-state-bucket-random"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}