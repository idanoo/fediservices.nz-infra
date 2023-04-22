resource "aws_vpc" "vpc" {
  cidr_block           = "10.10.10.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "mainVPC" }
}

resource "aws_subnet" "subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.10.${16 * count.index}/28"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = { Name = "mainSubnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = { Name = "mainIGW" }
}

data "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "igw" {
  route_table_id         = data.aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "association" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = data.aws_route_table.rt.id
}
