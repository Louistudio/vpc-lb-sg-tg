resource "aws_vpc" "v1" {
  cidr_block           = "172.120.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name   = "utc-app"
    team   = "cloud-team"
    author = "Johnny-Louis"
  }
}

# internet gateway
resource "aws_internet_gateway" "gtw" {
  vpc_id = aws_vpc.v1.id
}

#public subnet
resource "aws_subnet" "pub1" {
  vpc_id                  = aws_vpc.v1.id
  cidr_block              = "172.120.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "pub2" {
  vpc_id                  = aws_vpc.v1.id
  cidr_block              = "172.120.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

#private subnet
resource "aws_subnet" "private1" {
  availability_zone = "us-east-1a"
  cidr_block        = "172.120.3.0/24"
  vpc_id            = aws_vpc.v1.id

}

resource "aws_subnet" "private2" {
  availability_zone = "us-east-1b"
  cidr_block        = "172.120.4.0/24"
  vpc_id            = aws_vpc.v1.id

}

#NAT gateway
resource "aws_eip" "eip1" {}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.pub1.id
}


#private route table
resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.v1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }

}

resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.v1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw.id
  }

}

#public table
resource "aws_route_table_association" "purt1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.rtpublic.id

}

resource "aws_route_table_association" "purt2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.rtpublic.id

}

#private table
resource "aws_route_table_association" "prirt1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.rtprivate.id

}
resource "aws_route_table_association" "prirt2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.rtprivate.id

}
