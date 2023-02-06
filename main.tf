provider "aws" {
  region="ap-south-1"
}

resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.custom.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/24"
}


resource "aws_subnet" "private" {
  vpc_id = aws_vpc.custom.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "customigw" {
  vpc_id = aws_vpc.custom.id
}

resource "aws_route_table" "route" {
    vpc_id = aws_vpc.custom.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.customigw.id
    }
}

resource "aws_route_table_association" "subnet-association" {
  route_table_id = aws_route_table.route.id
  subnet_id = aws_subnet.public.id
}
