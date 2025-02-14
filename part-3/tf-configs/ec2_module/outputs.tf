output "instance_public_ip" {
  description = "The public IP of the instance"
  value       = aws_instance.web-2.public_ip
}