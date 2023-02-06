# this is for giving the provider name
provider "aws" {
  region="ap-south-1"
}
#this is for creating a vpc

resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"
}

#this is for creating a subnet public subnet

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.custom.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/24"
}

#this is for creating a private subnet

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.custom.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

#this is for creating a internet gateway

resource "aws_internet_gateway" "customigw" {
  vpc_id = aws_vpc.custom.id
}

#this is for creating route table

resource "aws_route_table" "route" {
    vpc_id = aws_vpc.custom.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.customigw.id
    }
}

#this is for creating subnet association

resource "aws_route_table_association" "subnet-association" {
  route_table_id = aws_route_table.route.id
  subnet_id = aws_subnet.public.id
}
