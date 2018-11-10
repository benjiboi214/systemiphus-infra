data "aws_availability_zone" "systemiphus_primary" {
  name = "${var.systemiphus_aws_az}"
}
data "aws_ami" "systemiphus_nat_ami" {
  most_recent      = true
   filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
   filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
}