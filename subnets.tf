// Define the subnets contained inside each VPC
resource "aws_subnet" "systemiphus_public_subnet" {
    vpc_id = "${aws_vpc.systemiphus.id}"
    cidr_block = "${cidrsubnet(aws_vpc.systemiphus.cidr_block, 8, 0)}"
    availability_zone = "${var.systemiphus_aws_az}"
}

resource "aws_subnet" "systemiphus_private_subnet" {
    vpc_id = "${aws_vpc.systemiphus.id}"
    cidr_block = "${cidrsubnet(aws_vpc.systemiphus.cidr_block, 8, 1)}"
    availability_zone = "${var.systemiphus_aws_az}"
}

resource "aws_subnet" "systemiphus_vpn_subnet" {
    vpc_id = "${aws_vpc.systemiphus.id}"
    cidr_block = "${cidrsubnet(aws_vpc.systemiphus.cidr_block, 8, 2)}"
    availability_zone = "${var.systemiphus_aws_az}"
}