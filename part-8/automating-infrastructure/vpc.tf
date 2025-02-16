resource "aws_vpc" "AppVPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AppVPC"
  }
}

resource "aws_subnet" "AppSubnet1" {
  vpc_id            = aws_vpc.AppVPC.id
  cidr_block        = var.subnet_cidrs["subnet1"]
  availability_zone = var.availability_zones["az1"]

  tags = {
    Name = "AppSubnet1"
  }
}

resource "aws_subnet" "AppSubnet2" {
  vpc_id            = aws_vpc.AppVPC.id
  cidr_block        = var.subnet_cidrs["subnet2"]
  availability_zone = var.availability_zones["az2"]

  tags = {
    Name = "AppSubnet2"
  }
}

resource "aws_db_subnet_group" "app_db_subnet_group" {
  name       = "app-db-subnet-group"
  subnet_ids = [aws_subnet.AppSubnet1.id, aws_subnet.AppSubnet2.id]  

  tags = {
    Name = "AppDBSubnetGroup"
  }
}