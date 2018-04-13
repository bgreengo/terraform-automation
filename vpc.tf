# Internet VPC
resource "aws_vpc" "wordpress-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "wordpress-vpc"
    }
}


# Subnets
resource "aws_subnet" "wp-public-1" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-2a"

    tags {
        Name = "wp-public-1"
    }
}
resource "aws_subnet" "wp-public-2" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-2b"

    tags {
        Name = "wp-public-2"
    }
}
resource "aws_subnet" "wp-public-3" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-2c"

    tags {
        Name = "wp-public-3"
    }
}
resource "aws_subnet" "wp-private-1" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2a"

    tags {
        Name = "wp-private-1"
    }
}
resource "aws_subnet" "wp-private-2" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2b"

    tags {
        Name = "wp-private-2"
    }
}
resource "aws_subnet" "wp-private-3" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2c"

    tags {
        Name = "wp-private-3"
    }
}

# Internet GW
resource "aws_internet_gateway" "wp-igw" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"

    tags {
        Name = "wp-igw"
    }
}

# route tables
resource "aws_route_table" "wp-public" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.wp-igw.id}"
    }

    tags {
        Name = "wp-public-1"
    }
}

# route associations public
resource "aws_route_table_association" "wp-public-1-a" {
    subnet_id = "${aws_subnet.wp-public-1.id}"
    route_table_id = "${aws_route_table.wp-public.id}"
}
resource "aws_route_table_association" "wp-public-2-a" {
    subnet_id = "${aws_subnet.wp-public-2.id}"
    route_table_id = "${aws_route_table.wp-public.id}"
}
resource "aws_route_table_association" "wp-public-3-a" {
    subnet_id = "${aws_subnet.wp-public-3.id}"
    route_table_id = "${aws_route_table.wp-public.id}"
}
resource "aws_route_table" "wp-private" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
    }

    tags {
        Name = "wp-private-1"
    }
}
# route associations private
resource "aws_route_table_association" "wp-private-1-a" {
    subnet_id = "${aws_subnet.wp-private-1.id}"
    route_table_id = "${aws_route_table.wp-private.id}"
}
resource "aws_route_table_association" "wp-private-2-a" {
    subnet_id = "${aws_subnet.wp-private-2.id}"
    route_table_id = "${aws_route_table.wp-private.id}"
}
resource "aws_route_table_association" "wp-private-3-a" {
    subnet_id = "${aws_subnet.wp-private-3.id}"
    route_table_id = "${aws_route_table.wp-private.id}"
}
# nat gw
resource "aws_eip" "nat" {
  vpc      = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.wp-public-1.id}"
  depends_on = ["aws_internet_gateway.wp-igw"]
}
