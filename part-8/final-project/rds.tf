# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}

# RDS MySQL Instance
resource "aws_db_instance" "rds_instance" {
  identifier            = "app-database"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  db_name               = var.db_name
  username              = var.db_username
  password              = var.db_password
  parameter_group_name  = "default.mysql8.0"
  publicly_accessible   = false
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}