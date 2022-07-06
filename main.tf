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