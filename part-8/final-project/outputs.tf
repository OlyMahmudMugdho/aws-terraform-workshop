output "instance_ids" {
  description = "IDs of created EC2 instances"
  value = {
    WebServer1 = aws_instance.WebServer1.id
    WebServer2 = aws_instance.WebServer2.id
  }
}

output "public_ips" {
  description = "Public IPs of the instances"
  value = {
    WebServer1 = aws_eip.public_ip1.public_ip
    WebServer2 = aws_eip.public_ip2.public_ip
  }
}

output "route_table_id" {
  description = "ID of the main route table"
  value       = aws_route_table.AppRouteTable.id
}

output "database_endpoint" {
  description = "Database connection endpoint"
  value       = aws_db_instance.app_database.endpoint
}