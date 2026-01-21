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