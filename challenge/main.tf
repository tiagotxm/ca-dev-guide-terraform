terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
  }

  backend "s3" {
    bucket         = "terraformstate33884612"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "subnet"
  }
}

resource "aws_instance" "server" {
  ami                    = "ami-0d398eb3480cb04e7"
  instance_type          = var.instance_size
  monitoring             = false
  vpc_security_group_ids = [aws_vpc.prod.default_security_group_id]
  subnet_id              = aws_subnet.sub1.id
  root_block_device {
    delete_on_termination = false
    encrypted             = true
    volume_size           = 20
    volume_type           = "standard"
  }
  tags = {
    Name = var.servername
  }
}
