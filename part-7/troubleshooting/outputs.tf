output "instance_id" {
  description = "ID of the main EC2 instance"
  value       = aws_instance.ec2-instance.id
}

output "instance_public_ip" {
  description = "Public IP of the main EC2 instance"
  value       = aws_instance.ec2-instance.public_ip
}

output "instance_a_public_ip" {
  description = "Public IP of instance A"
  value       = aws_instance.instance_a.public_ip
}

output "instance_b_public_ip" {
  description = "Public IP of instance B"
  value       = aws_instance.instance_b.public_ip
}

output "random_pet_name" {
  description = "Generated random pet name"
  value       = random_pet.my_pet.id
}