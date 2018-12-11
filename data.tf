data "aws_availability_zone" "systemiphus_primary" {
  name = "${var.systemiphus_aws_az}"
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