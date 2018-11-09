// Define the subnets contained inside each VPC

resource "null_resource" "systemiphus_subnet" {
    triggers = {
        public_cidr = "${cidrsubnet(aws_vpc.systemiphus.cidr_block, 8, 0)}"
        private_cidr = "${cidrsubnet(aws_vpc.systemiphus.cidr_block, 8, 1)}"
    }
}

resource "aws_subnet" "systemiphus_public_subnet" {
    vpc_id = "${aws_vpc.systemiphus.id}"
    cidr_block = "${null_resource.systemiphus_subnet.triggers.public_cidr}"
    availability_zone = "${var.systemiphus_aws_az}"
}

resource "aws_subnet" "systemiphus_private_subnet" {
    vpc_id = "${aws_vpc.systemiphus.id}"
    cidr_block = "${null_resource.systemiphus_subnet.triggers.private_cidr}"
    availability_zone = "${var.systemiphus_aws_az}"
}

output "systemiphus_public_subnet" {
    value = "${aws_subnet.systemiphus_public_subnet.cidr_block}"
}

output "systemiphus_private_subnet" {
    value = "${aws_subnet.systemiphus_private_subnet.cidr_block}"
}