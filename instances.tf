output "nat_ami" {
    value = "${data.aws_ami.systemiphus_nat_ami.image_id}"
}