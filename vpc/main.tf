resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" : "${var.cluster_name}-VPC-${var.environment}"
    "Environment" : var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

  }
}

data "aws_availability_zones" "available" {
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    "Name" : "${var.cluster_name}-IGW-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_eip" "eip_nat" {
  count = var.number_private_subnets
  domain = "vpc"
  tags = {
    "Name" : "${var.cluster_name}-EIP-NAT-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_nat_gateway" "main" {
  count = var.number_private_subnets
  allocation_id = "${element(aws_eip.eip_nat.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on = [ aws_internet_gateway.main ]
  
  tags = {
    "Name" : "${var.cluster_name}-NAT-${var.environment}"
    "Environment" : var.environment
  }
}


resource "aws_subnet" "public" {
  count = var.number_public_subnets
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = "10.0.${count.index+1}.0/24"
  map_public_ip_on_launch = true

tags = {
    "Name" : "${var.cluster_name}-SUB_PUBL-${var.environment}"
    "Environment" : var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}

resource "aws_subnet" "private" {
  count = var.number_private_subnets
  vpc_id = "${aws_vpc.main.id}"
  availability_zone =  data.aws_availability_zones.available.names[count.index]
  cidr_block = "10.0.${count.index+3}.0/24"
  
  tags = {
    "Name" : "${var.cluster_name}-SUB_PRIV-${var.environment}"
    "Environment" : var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count = var.number_private_subnets
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.main.*.id, count.index)}"
  }
  tags = {
    "Name" : "${var.cluster_name}-RT-PRIV-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags = {
    "Name" : "${var.cluster_name}-RT_PUBL-${var.environment}"
    "Environment" : var.environment
  }
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          =  var.number_public_subnets
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id,count.index)}"
}
resource "aws_route_table_association" "private" {
  count          =  var.number_private_subnets
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id,count.index)}"
}


















