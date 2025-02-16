resource "aws_instance" "ec2-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "ec2-instance"
  }
}

resource "local_file" "ec2_details" {
  filename = "ec2_details.txt"
  content  = "New EC2 instance created with ID: ${aws_instance.ec2-instance.id} and IP: ${aws_instance.ec2-instance.public_ip}"
}

resource "random_pet" "my_pet" {
  length = var.pet_length
  prefix = var.pet_prefix
}

resource "aws_instance" "instance_a" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "InstanceA"
  }
}

resource "aws_instance" "instance_b" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "InstanceB"
  }

  user_data = <<EOF
#!/bin/bash
mkdir -p /var/www/html/
echo "Instance A Public IP: ${aws_instance.instance_a.public_ip}" > /var/www/html/index.html
EOF
}