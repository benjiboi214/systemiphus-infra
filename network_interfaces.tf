resource "aws_network_interface" "nat_private_interface" {
  subnet_id       = "${aws_subnet.systemiphus_private_subnet.id}"
  private_ips     = ["${null_resource.systemiphus_nat_instance_private.triggers.private_ip}"]
  security_groups = ["${aws_security_group.systemiphus_private_sg.id}"]
}

resource "aws_network_interface" "nat_public_interface" {
  subnet_id       = "${aws_subnet.systemiphus_public_subnet.id}"
  private_ips     = ["${null_resource.systemiphus_nat_instance_public.triggers.private_ip}"]
  security_groups = ["${aws_security_group.systemiphus_nat_sg.id}"]
  source_dest_check = false
}