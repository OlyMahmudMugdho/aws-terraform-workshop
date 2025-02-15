data "aws_instance" "new_instance" {
  instance_id = "<ID_from_console>"
}

output "nontf_instance_ip" {
  value = data.aws_instance.new_instance.public_ip
}