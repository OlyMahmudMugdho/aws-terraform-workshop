module "web_instance" {
  source        = "../ec2_module"
  ami           = var.ami
  instance_type = var.instance_type
  instance_name = var.instance_name
}

