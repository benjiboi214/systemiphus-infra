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
resource "null_resource" "public_subnet_ranges" {
    triggers = {
        public_a_cidr = "${cidrsubnet(aws_vpc.primary.cidr_block, 8, 0)}"
        public_b_cidr = "${cidrsubnet(aws_vpc.primary.cidr_block, 8, 1)}"
    }
}

resource "null_resource" "private_subnet_ranges" {
    triggers = {
        private_a_cidr = "${cidrsubnet(aws_vpc.primary.cidr_block, 8, 2)}"
        private_b_cidr = "${cidrsubnet(aws_vpc.primary.cidr_block, 8, 3)}"
    }
}

# Public Subnets
resource "aws_subnet" "primary_public_a" {
    vpc_id = "${aws_vpc.primary.id}"
    cidr_block = "${null_resource.public_subnet_ranges.triggers.public_a_cidr}"
    availability_zone = "${var.az_1}"

    tags = {
        Name = "subnet-sys-primary-public-a"
    }
}

resource "aws_subnet" "primary_public_b" {
    vpc_id = "${aws_vpc.primary.id}"
    cidr_block = "${null_resource.public_subnet_ranges.triggers.public_b_cidr}"
    availability_zone = "${var.az_2}"

    tags = {
        Name = "subnet-sys-primary-public-b"
    }
}


# Private Subnets
resource "aws_subnet" "primary_private_a" {
    vpc_id = "${aws_vpc.primary.id}"
    cidr_block = "${null_resource.private_subnet_ranges.triggers.private_a_cidr}"
    availability_zone = "${var.az_1}"

    tags = {
        Name = "subnet-sys-primary-private-a"
    }
}
resource "aws_subnet" "primary_private_b" {
    vpc_id = "${aws_vpc.primary.id}"
    cidr_block = "${null_resource.private_subnet_ranges.triggers.private_b_cidr}"
    availability_zone = "${var.az_2}"

    tags = {
        Name = "subnet-sys-primary-private-b"
    }
}

# Public Routes
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.primary.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.primary.id}"
    }
}

resource "aws_route_table_association" "public_a" {
    route_table_id = "${aws_route_table.public.id}"
    subnet_id = "${aws_subnet.primary_public_a.id}"
}

resource "aws_route_table_association" "public_b" {
    route_table_id = "${aws_route_table.public.id}"
    subnet_id = "${aws_subnet.primary_public_b.id}"
}

# Private Routes
resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.primary.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.vpn.id}"
    }
    
}

resource "aws_route_table_association" "private_a" {
    route_table_id = "${aws_route_table.private.id}"
    subnet_id = "${aws_subnet.primary_private_a.id}"
}

resource "aws_route_table_association" "private_b" {
    route_table_id = "${aws_route_table.private.id}"
    subnet_id = "${aws_subnet.primary_private_b.id}"
}

# NAT Instance
resource "null_resource" "vpn" {
    triggers = {
        private_ip = "${cidrhost(null_resource.public_subnet_ranges.triggers.public_a_cidr, 10)}"
    }
}

resource "aws_instance" "vpn" {
    ami = "${var.ubuntu_1604_ami}"
    instance_type = "${var.vpn_instance_size}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.primary_public_a.id}"
    private_ip = "${null_resource.vpn.triggers.private_ip}"
    source_dest_check = false
    vpc_security_group_ids = ["${aws_security_group.public.id}"]

    root_block_device {
        volume_type = "standard"
        volume_size = 8
        delete_on_termination = "true"
    }

    tags = {
        Name = "inst-sys-vpn"
    }
}

resource "aws_eip" "vpn" {
    vpc = true
    instance = "${aws_instance.vpn.id}"
}

output "vpn_instance_public_ip" {
    value = "${aws_eip.vpn.public_ip}"
}
