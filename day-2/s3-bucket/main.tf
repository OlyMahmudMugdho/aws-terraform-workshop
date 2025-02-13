resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket
  acl = "private"

  versioning {
    enabled = true
  }
}

data "aws_secretsmanager_secret_version" "database_password" {
  secret_id = var.secret_id
}

resource "aws_db_instance" "my_secret_db" {
  identifier        = var.db_identifier
  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  username          = var.db_username
  password          = data.aws_secretsmanager_secret_version.database_password.secret_string
}