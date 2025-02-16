variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}


variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-06c68f701d8090592"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name"
  type        = string
  default     = "my-key-pair"
}

variable "pet_length" {
  description = "Length of random pet name"
  type        = number
  default     = 3
}

variable "pet_prefix" {
  description = "Prefix for random pet name"
  type        = string
  default     = "Mr."
}
