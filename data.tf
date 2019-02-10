data "aws_availability_zone" "systemiphus_primary" {
  name = "${var.systemiphus_primary_aws_az}"
}
data "aws_ami" "systemiphus_nat_ami" {
  most_recent      = true
   filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
   filter {
    name   = "name"
    values = ["${var.systemiphus_nat_ami_name}"]
  }
}
data "aws_ami" "systemiphus_centos_ami" {
  most_recent = true
  
  filter {
    name = "owner-alias"
    values = ["aws-marketplace"]
  }
  filter {
    name = "product-code"
    values = ["${var.systemiphus_centos_product_code}"]
  }
}