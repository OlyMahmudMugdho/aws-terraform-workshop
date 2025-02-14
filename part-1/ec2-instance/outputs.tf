# Output the EC2 instance's public IP for SSH connection
output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}

# Output the key name for the key pair
output "key_name" {
  value = aws_key_pair.my_key.key_name
}

# Output the security group ID
output "security_group_id" {
  value = aws_security_group.ssh_access.id
}
