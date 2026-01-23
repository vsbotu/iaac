resource "aws_vpc" "iaac_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true 
    enable_dns_hostnames = true
    tags = {
        Name = var.name
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.iaac_vpc.id
    tags = {
        Name = "${var.name}-igw"
    }
}

resource "aws_subnet" "public" {
    for_each = var.public_subnets
    vpc_id = aws_vpc.iaac_vpc.id
    cidr_block = each.value
    availability_zone = each.key
    map_public_ip_on_launch = true
    tags ={
        Name = "${var.name}-public-subnet-${each.key}"
    }
}

resource "aws_subnet" "private" {
    for_each = var.private_subnets
    vpc_id = aws_vpc.iaac_vpc.id
    cidr_block = each.value
    availability_zone = each.key
    tags = {
        Name = "${var.name}-private-subnet-${each.key}"
    }    
}

resource "aws_eip" "nat_ip" {
    domain = "vpc"
    tags = {
        Name = "${var.name}-nat-eip"
    }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = {
    Name = "${var.name}-nat_gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.iaac_vpc.id
    tags = {
        Name = "${var.name}-private-rt"
    }
}

resource "aws_route" "private-nat" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}


#Public route table 

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.iaac_vpc.id
    tags = {
        Name = "${var.name}-public-rt"
    }
}

resource "aws_route" "public-igw" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
    for_each = aws_subnet.public
    subnet_id = each.value.id
    route_table_id = aws_route_table.public
}