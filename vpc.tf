
// The VPC declaration file
resource "aws_vpc" "systemiphus" {
  cidr_block = "${cidrsubnet(var.systemiphus_base_cidr_block,
                             8,
                             var.systemiphus_region_map[data.aws_availability_zone.systemiphus_primary.region])}"

  tags {
    Name = "systemiphus"
  }
}

resource "aws_internet_gateway" "systemiphus_igw" {
  vpc_id = "${aws_vpc.systemiphus.id}"
}