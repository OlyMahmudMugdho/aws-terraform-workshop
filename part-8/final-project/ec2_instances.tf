# EC2 Instances (Web Servers)
resource "aws_instance" "web_server1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  tags = { Name = "WebServer1" }
}

resource "aws_instance" "web_server2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  tags = { Name = "WebServer2" }
}