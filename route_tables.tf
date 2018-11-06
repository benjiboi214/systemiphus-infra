resource "aws_route_table" "systemiphus_public" {
    vpc_id = "${aws_vpc.systemiphus.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.systemiphus_igw.id}"
    }
}

resource "aws_route_table" "systemiphus_private" {
    vpc_id = "${aws_vpc.systemiphus.id}"

    # route {
    #     cidr_block = "0.0.0.0/0"
    #     nat_gateway_id = "${}"
    # }
}