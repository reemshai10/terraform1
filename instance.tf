resource "aws_instance" "reem_easy1" {
    ami = "ami-052cef05d01020f1d"
    instance_type = "t2.micro"
    subnet_id                   = aws_subnet.ter_sub_reem1.id
    associate_public_ip_address = true
    key_name                    = "reem_key_aws"
    security_groups = [aws_security_group.ter_reem_sg_instance.id]
    tags = {
    Name = "reem_easy1"
    }
}
resource "aws_instance" "reem_easy2" {
    ami = "ami-052cef05d01020f1d"
    instance_type = "t2.micro"
    subnet_id                   = aws_subnet.ter_sub_reem2.id
    associate_public_ip_address = true
    key_name                    = "reem_key_aws"
    security_groups = [aws_security_group.ter_reem_sg_instance.id]
    tags = {
    Name = "reem_easy2"
    }
}