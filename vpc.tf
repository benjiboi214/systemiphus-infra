
// The VPC declaration file
resource "aws_vpc" "systemiphus" {
  cidr_block       = "10.0.0.0/16"

  tags {
    Name = "systemiphus"
  }
}