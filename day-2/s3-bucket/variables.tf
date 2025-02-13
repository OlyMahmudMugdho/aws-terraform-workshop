variable "aws_access_key_id" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
  sensitive   = true
}


variable "region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "bucket" {
  description = "The name of the S3 bucket"
  type        = string
}
