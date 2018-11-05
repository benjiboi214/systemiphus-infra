
// The VPC declaration file
resource "aws_vpc" "systemiphus" {
  cidr_block = "${cidrsubnet(var.systemiphus_base_cidr_block,
                             8,
                             var.systemiphus_region_map[data.aws_availability_zone.systemiphus_primary.region])}"

  tags {
    Name = "systemiphus"
  }
}