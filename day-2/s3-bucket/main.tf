# main.tf
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket
}