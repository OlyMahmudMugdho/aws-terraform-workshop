variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type        = map(string)
  default     = {
    subnet1 = "10.0.1.0/24"
    subnet2 = "10.0.2.0/24"
  }
}

variable "availability_zones" {
  description = "Availability zones"
  type        = map(string)
  default     = {
    az1 = "us-east-1a"
    az2 = "us-east-1b"
  }
}

variable "db_config" {
  description = "Database configuration"
  type        = map(string)
  default     = {
    allocated_storage = "20"
    engine           = "mysql"
    engine_version   = "8.0.33"
    instance_class   = "db.t3.micro"
    identifier       = "appdatabase"
    name            = "appdatabase"
    username        = "admin"
  }
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "db*pass123"
}

variable "instance_config" {
  description = "EC2 instance configuration"
  type        = map(string)
  default     = {
    ami           = "ami-06c68f701d8090592"
    instance_type = "t2.micro"
    key_name      = "my-ec2-key"
  }
}