locals {
  prefix = "eks-cluster"
}

terraform {
  required_version = ">= 0.12.20"

  required_providers {
    aws        = ">= 2.51.0"
  }
}

provider "aws" {
    region = "eu-west-1"
    profile = var.profile
}

resource "aws_key_pair" "keypair" {
  key_name = "${local.prefix}-k8s"
  public_key = var.publickey
  tags = {
      Name = "${local.prefix}-keypair"
  }
}
