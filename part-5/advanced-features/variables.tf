variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-06c68f701d8090592"
}

variable "access_key" {
  description = "AWS access"
}

variable "secret_key" {
  description = "AWS secret"
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "my-terraform-key"
}

variable "private_key_path" {
  description = "Path to private key file"
  type        = string
  default     = "/home/mugdho/my-terraform-key.pem"
}

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type        = string
  default     = "NginxServer"
}

variable "security_group_name" {
  description = "Name prefix for security group"
  type        = string
  default     = "allow_ssh_http"
}