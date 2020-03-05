provider "aws" {
    region = "eu-west-1"
    profile = "d2si"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
      Name = "IGW"
  }
}

resource "aws_subnet" "subnet" {
    count = length(data.aws_availability_zones.zone.names)
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
    availability_zone = element(data.aws_availability_zones.zone.names, count.index)
}
