terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

module "my_vpc" {
  source = "./modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  public_sub_1_cidr  = "10.0.1.0/24"
  private_sub_1_cidr = "10.0.2.0/24"
}

data "aws_ami" "amz_linux_2" {
  most_recent = true
  name_regex  = "amzn2-ami-hvm-2.*.1-x86_64-gp2"
  owners      = ["amazon"]
}

resource "aws_instance" "web_instance" {
  ami           = data.aws_ami.amz_linux_2.id
  instance_type = "t2.nano"

  subnet_id                   = module.my_vpc.public_subnet_id
  vpc_security_group_ids      = module.my_vpc.public_sg_id
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex
  amazon-linux-extras install nginx1 -y
  systemctl enable nginx
  systemctl start nginx
  EOF
}