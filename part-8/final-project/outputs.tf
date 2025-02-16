output "web_server1_public_ip" {
  value = ""  # No public IP for private instances
}

output "web_server2_public_ip" {
  value = ""  # No public IP for private instances
}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}

output "load_balancer_dns_name" {
  value = aws_lb.application_load_balancer.dns_name
}