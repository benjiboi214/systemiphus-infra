resource "aws_eip" "systemiphus_nat_ip" {
    vpc = true

    instance                  = "${aws_instance.bastion_host.id}"
    associate_with_private_ip = "${null_resource.systemiphus_nat_instance.triggers.private_ip}"
    depends_on                = ["aws_internet_gateway.systemiphus_igw"]
}

output "nat_instance_public_ip" {
    value = "${aws_eip.systemiphus_nat_ip.public_ip}"
}