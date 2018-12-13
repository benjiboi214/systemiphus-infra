resource "aws_eip" "systemiphus_bastion_ip" {
    vpc = true
    instance                  = "${aws_instance.bastion_host.id}"
}

output "bastion_instance_public_ip" {
    value = "${aws_eip.systemiphus_bastion_ip.public_ip}"
}

resource "aws_eip" "systemiphus_nat_ip" {
    vpc = true
    instance                  = "${aws_instance.nat_host.id}"
}

output "nat_instance_public_ip" {
    value = "${aws_eip.systemiphus_nat_ip.public_ip}"
}