## VPC
resource "aws_vpc" "primary" {
  enable_dns_support = true
  enable_dns_hostnames = true
  cidr_block = "${var.primary_cidr}"

  tags = {
    Name = "vpc-sys-primary"
  }
}

## Internet Gateway
resource "aws_internet_gateway" "primary" {
  vpc_id = "${aws_vpc.primary.id}"

  tags = {
    Name = "igw-sys-primary"
  }
}

## Subnets
resource "null_resource" "subnet_ranges" {
    triggers = {
        public_cidr = "${cidrsubnet(aws_vpc.primary.cidr_block, 8, 0)}"
        private_cidr = "${cidrsubnet(aws_vpc.primary.cidr_block, 8, 1)}"
    }
}

output "private_subnet_cidr" {
    value = "${null_resource.subnet_ranges.triggers.private_cidr}"
}
output "public_subnet_cidr" {
    value = "${null_resource.subnet_ranges.triggers.public_cidr}"
}

resource "aws_subnet" "primary_public" {
    vpc_id = "${aws_vpc.primary.id}"
    cidr_block = "${null_resource.subnet_ranges.triggers.public_cidr}"
    availability_zone = "${var.az_1}"

    tags = {
        Name = "subnet-sys-primary-public"
    }
}

resource "aws_subnet" "primary_private" {
    vpc_id = "${aws_vpc.primary.id}"
    cidr_block = "${null_resource.subnet_ranges.triggers.private_cidr}"
    availability_zone = "${var.az_2}"

    tags = {
        Name = "subnet-sys-primary-private"
    }
}

## Route Tables
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.primary.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.primary.id}"
    }
}

resource "aws_route_table_association" "public" {
    route_table_id = "${aws_route_table.public.id}"
    subnet_id = "${aws_subnet.primary_public.id}"
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.primary.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
        # gateway_id = "${aws_internet_gateway.primary.id}"
    }
    
}

resource "aws_route_table_association" "private" {
    route_table_id = "${aws_route_table.private.id}"
    subnet_id = "${aws_subnet.primary_private.id}"
}

# NAT Instance
resource "null_resource" "nat" {
    triggers = {
        private_ip = "${cidrhost(null_resource.subnet_ranges.triggers.public_cidr, 10)}"
    }
}

resource "aws_instance" "nat" {
    ami = "${var.ubuntu_1604_ami}"
    instance_type = "${var.nat_instance_size}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.primary_public.id}"
    private_ip = "${null_resource.nat.triggers.private_ip}"
    source_dest_check = false
    vpc_security_group_ids = ["${aws_security_group.public.id}"]

    root_block_device {
        volume_type = "standard"
        volume_size = 8
        delete_on_termination = "true"
    }

    tags = {
        Name = "inst-sys-nat"
    }
}

resource "aws_eip" "nat" {
    vpc = true
    instance = "${aws_instance.nat.id}"
}

output "nat_instance_public_ip" {
    value = "${aws_eip.nat.public_ip}"
}
