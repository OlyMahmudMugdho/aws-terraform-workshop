output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.allow_ssh_http.id
}