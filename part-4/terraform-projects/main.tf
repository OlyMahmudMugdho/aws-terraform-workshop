resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "main-subnet"
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# The old EC2 instance resource, we will not use this anymore by our tf config
# resource "aws_instance" "ec2-1" {
#   ami           = "ami-06c68f701d8090592"
#   instance_type = "t2.micro"

#   subnet_id            = aws_subnet.main_subnet.id
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id]
#   key_name             = "myTerraformKey"  

#   tags = {
#     Name = "ec2-instance-1"
#   }
# }

# The new EC2 instance resource using the AWS provider
resource "aws_instance" "ec2-backup" {
  ami           = "ami-06c68f701d8090592"
  instance_type = "t2.micro"

  # Replace with the actual subnet ID where you want to place ec2-instance-2
  subnet_id            = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name             = "myTerraformKey"

  tags = {
    Name = "ec2-instance-2"
  }
}




resource "aws_s3_bucket" "sample_bucket" {
  bucket = "sample-bucket-${random_id.bucket_suffix.hex}"
  acl    = "private"

  tags = {
    Name = "sample-bucket"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
