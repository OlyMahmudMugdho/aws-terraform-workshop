resource "aws_db_instance" "app_database" {
  allocated_storage    = var.db_config["allocated_storage"]
  engine               = var.db_config["engine"]
  engine_version       = var.db_config["engine_version"]
  instance_class       = var.db_config["instance_class"]
  identifier           = var.db_config["identifier"]
  db_name              = var.db_config["name"]
  username             = var.db_config["username"]
  password             = var.db_password 
  publicly_accessible     = true
  db_subnet_group_name = aws_db_subnet_group.app_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.WebTrafficSG.id]

  tags = {
    Name = "AppDatabase"
  }
}