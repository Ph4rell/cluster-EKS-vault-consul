resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
      Name = "${local.prefix}-VPC"
      "kubernetes.io/cluster/${local.prefix}" = "shared"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
      Name = "${local.prefix}-IGW"
  }
}

resource "aws_subnet" "subnet" {
    count = length(data.aws_availability_zones.zone.names)
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
    availability_zone = element(data.aws_availability_zones.zone.names, count.index)
    map_public_ip_on_launch = true
    tags = {
        "kubernetes.io/cluster/eks-cluster" = "shared"
    }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${local.prefix}-routetable"
    }
}

resource "aws_route_table_association" "rt_association" {
    count = length(data.aws_availability_zones.zone.names)
    subnet_id = element(aws_subnet.subnet.*.id, count.index)
    route_table_id = aws_route_table.rt.id
}
