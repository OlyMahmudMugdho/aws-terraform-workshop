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

variable "aws_region" {
  description = "AWS region"
  type        = string
}

# Variable for the key name
variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = "my-key.pem"
}

# Variable for the public key file
variable "public_key" {
  description = "Path to the public key file"
  type        = string
  default     = "my-key.pem.pub"
}

# Variable for the security group name
variable "security_group_name" {
  description = "The name of the security group for SSH access"
  type        = string
  default     = "allow_ssh"
}

# Variable for the AMI ID
variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-01b799c439fd5516a"
}

# Variable for instance type
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}
