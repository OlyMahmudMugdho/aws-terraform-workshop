resource "aws_instance" "ec2_instance" {
    ami = "ami-01b799c439fd5516a"
    instance_type = "t2.micro"
}