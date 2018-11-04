// Define the subnets contained inside each VPC
resource "aws_subnet" "systemiphus_public_subnet" {
    vpc_id = "${aws_vpc.systemiphus.id}"
    cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "systemiphus_private_subnet" {
    vpc_id = "${aws_vpc.systemiphus.id}"
    cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "systemiphus_vpn_subnet" {
    vpc_id = "${aws_vpc.systemiphus.id}"
    cidr_block = "10.0.2.0/24"
}