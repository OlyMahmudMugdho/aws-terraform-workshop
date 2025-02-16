aws_region     = "us-east-1"
vpc_cidr       = "10.0.0.0/16"
subnet_cidrs = {
  subnet1 = "10.0.1.0/24"
  subnet2 = "10.0.2.0/24"
}
availability_zones = {
  az1 = "us-east-1a"
  az2 = "us-east-1b"
}
db_config = {
  allocated_storage = "20"
  engine           = "mysql"
  engine_version   = "8.0.33"
  instance_class   = "db.t3.micro"
  identifier       = "appdatabase"
  name            = "appdatabase"
  username        = "admin"
}
instance_config = {
  ami           = "ami-06c68f701d8090592"
  instance_type = "t2.micro"
  key_name      = "my-ec2-key"
}