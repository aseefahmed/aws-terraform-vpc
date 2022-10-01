# creating the vpc 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = merge(
    {
      "Name" = "${var.vpc_name}"
    }
  )

}

# subnets Public
resource "aws_subnet" "public_subnets" {
  count = length(var.vpc_public_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.vpc_public_subnets, count.index)
  availability_zone       = element(var.vpc_availability_zones, count.index)

  tags = merge(
    {
      "Name" = "private-subnet-${element(var.vpc_availability_zones, count.index)}"
    }
  )

}

# subnets Private
resource "aws_subnet" "private_subnets" {
  count = length(var.vpc_private_subnets)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.vpc_private_subnets, count.index)
  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = merge(
    {
      "Name" = "private-subnet-${element(var.vpc_availability_zones, count.index)}"
    }
  )

}

#igw and vpc 
resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = "${var.environment}-${var.vpc_name}-igw"
    }
  )

}

#eip for nat
resource "aws_eip" "elastic_ip" {
  vpc = true


  tags = merge(
    {
      "Name" = "${var.environment}-${var.vpc_name}-nat-gw"
    }
  )

}

#nat in the public_subnet 
resource "aws_nat_gateway" "aws_ng" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = merge(
    {
      "Name" = "${var.environment}-${var.vpc_name}-nat-gw"
    }
  )
}


#route table Public
resource "aws_route_table" "aws_public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id
  }

  tags = merge(
    {
      "Name" = "${var.environment}-${var.vpc_name}-public-route"
    }
  )

}

#route table Private
resource "aws_route_table" "aws_private_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws_ng.id
  }

  tags = merge(
    {
      "Name" = "${var.environment}-${var.vpc_name}-private-route"
    }
  )
}


#association of public route tables to public subnets
resource "aws_route_table_association" "public_subassocation" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.aws_public_route.id
}

#association of private route tables to private subnets
resource "aws_route_table_association" "private_subassocation" {
  count          = sum([length(var.vpc_private_subnets)])
  subnet_id      = element(concat(aws_subnet.private_subnets.*.id), count.index)
  route_table_id = aws_route_table.aws_private_route.id
}
