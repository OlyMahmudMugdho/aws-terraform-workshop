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


variable "secret_id" {
  description = "The secret ID for the database password"
  type        = string
}

variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "rds-db-instance"
}

variable "db_allocated_storage" {
  description = "Allocated storage size in GB"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
  default     = "gp2"
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "5.7"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  sensitive   = true
  default     = "admin"
}


