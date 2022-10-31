terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "uriya-dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "uriya-dev-vpc"
  }
}

resource "aws_internet_gateway" "uriya_igw" {
  vpc_id = aws_vpc.uriya-dev-vpc.id

  tags = {
    Name = "uriya_igw"
  }
}

resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.uriya-dev-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.uriya_igw.id
}




resource "aws_subnet" "uriya--k8s-subnet" {
  vpc_id     = aws_vpc.uriya-dev-vpc.id
  cidr_block = "10.0.0.0/27"
  tags = {
    "Name" = "uriya--k8s-subnet"
  }

}


resource "aws_network_interface" "nik_web_uriya" {
  subnet_id   = aws_subnet.uriya--k8s-subnet.id
  private_ips = ["10.0.0.28"]

  tags = {
    Name = "nik_web_uriya"
  }
}

resource "aws_instance" "web_server_uriya" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t3.small"




  associate_public_ip_address = true

  tags = {
    Name = "uriya_web_server"
  }

}
