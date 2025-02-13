region = "us-east-1"
bucket = "olymahmud-terraform-workshop-bucket"

secret_id = "my-database-password"

db_identifier        = "rds-db-instance"
db_allocated_storage = 20
db_storage_type      = "gp2"
db_engine            = "mysql"
db_engine_version    = "5.7"
db_instance_class    = "db.t3.micro"
db_username          = "admin"