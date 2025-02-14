resource "aws_vpc" "my_network" {
  cidr_block = var.vpc_cidr_block
}