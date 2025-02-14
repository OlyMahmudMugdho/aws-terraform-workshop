# Create a key pair
resource "aws_key_pair" "my_key" {
  key_name   = var.key_name
  public_key = file(var.public_key)
}

# Create a security group for SSH access
resource "aws_security_group" "ssh_access" {
  name        = var.security_group_name
  description = "Allow SSH inbound traffic from anywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP (change for security)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.ssh_access.name]

  tags = {
    Name = "Terraform-EC2"
  }
}
