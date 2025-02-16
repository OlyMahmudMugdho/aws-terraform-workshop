resource "aws_instance" "WebServer1" {
  ami             = var.instance_config["ami"]
  instance_type   = vae.instance_config["instance_type"]

  network_interface {
    network_interface_id = aws_network_interface.nw-interface1.id
    device_index = 0
  }

  key_name = var.instance_config["key_name"]

  tags = {
    Name = "WebServer1"
  }
}

resource "aws_instance" "WebServer2" {
  ami             = var.instance_config["ami"]
  instance_type   = var.instance_config["instance_type"]

  network_interface {
    network_interface_id = aws_network_interface.nw-interface2.id
    device_index = 0
  }

  key_name = var.instance_config["key_name"]

  tags = {
    Name = "WebServer2"
  }
}