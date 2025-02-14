variable "region" {
  type        = string
  description = "The AWS region to launch resources."
  default     = "us-east-1"
}

variable "aws_access_key_id" {
  type        = string
  description = "The AWS access key"
}

variable "aws_secret_access_key" {
  type        = string
  description = "The AWS secret key"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "web-instance"
  
}

variable "ami" {
  description = "EC2 AMI ID"
  default     = "ami-01b799c439fd5516a"
}