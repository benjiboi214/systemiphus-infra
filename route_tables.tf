resource "aws_route_table" "systemiphus_public" {
    vpc_id = "${aws_vpc.systemiphus.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.systemiphus_igw.id}"
    }
}

resource "aws_route_table_association" "systemiphus_public" {
    route_table_id = "${aws_route_table.systemiphus_public.id}"
    subnet_id = "${aws_subnet.systemiphus_public_subnet.id}"
}

resource "aws_route_table" "systemiphus_private" {
    vpc_id = "${aws_vpc.systemiphus.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.bastion_host.id}"
    }
}

resource "aws_route_table_association" "systemiphus_private" {
    route_table_id = "${aws_route_table.systemiphus_private.id}"
    subnet_id = "${aws_subnet.systemiphus_private_subnet.id}"
}
