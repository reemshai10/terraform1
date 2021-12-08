terraform{
 required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.14.1"
    }
  }
  required_version = ">= 0.13"
}
provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "ter_vpc_reem" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "ter_vpc_reem"
  }
}
resource "aws_subnet" "ter_sub_reem1" {
  # By referencing the aws_vpc.main object, Terraform knows that the subnet
  # must be created only after the VPC is created.
  vpc_id = aws_vpc.ter_vpc_reem.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "ter_sub_reem1"
  }
}
resource "aws_subnet" "ter_sub_reem2" {
  # By referencing the aws_vpc.main object, Terraform knows that the subnet
  # must be created only after the VPC is created.
  vpc_id = aws_vpc.ter_vpc_reem.id
  cidr_block = "10.0.1.0/28"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "ter_sub_reem2"
  }
}
resource "aws_internet_gateway" "ter_reem_gw" {
    vpc_id = aws_vpc.ter_vpc_reem.id
    tags = {
      Name = "ter_reem_gw"
    }
}
resource "aws_route_table" "ter_reem_RT" {
    vpc_id = aws_vpc.ter_vpc_reem.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ter_reem_gw.id
    }
     tags = {
      Name = "ter_reem_RT"
    }
}
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
resource "aws_security_group" "ter_reem_sg_instance" {
    vpc_id = aws_vpc.ter_vpc_reem.id
    description = "AWS sg for app instance"
    name = "sg_reem"
    ingress {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      self =true
      
    }
    ingress {
        description         = "Allow SSH from jump_server_sg"
        from_port           = 22
        to_port             = 22
        protocol            = "TCP"
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
    egress {
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"] 
        ipv6_cidr_blocks    = ["::/0"] 
    }
    tags = {
      Name = "ter_reem_sg"
    } 
}
resource "aws_security_group" "ter_reem_sg_lb" {
    vpc_id = aws_vpc.ter_vpc_reem.id
    description = "AWS sg for app lb"
    name = "sg_reem_lb"
    ingress {
        description         = "Allow SSH from jump_server_sg"
        from_port           = 22
        to_port             = 22
        protocol            = "TCP"
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
     egress {
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"] 
        ipv6_cidr_blocks    = ["::/0"] 
    }
    tags = {
      Name = "ter_reem_sg_lb"
    } 
}


