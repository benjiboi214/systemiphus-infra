resource "aws_instance" "testing" {
    ami = "${var.ubuntu_1604_ami}"
    instance_type = "${var.vpn_instance_size}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.primary_private.id}"
    private_ip = "10.1.1.10"
    source_dest_check = false
    vpc_security_group_ids = ["${aws_security_group.private.id}"]

    root_block_device {
        volume_type = "standard"
        volume_size = 8
        delete_on_termination = "true"
    }

    tags = {
        Name = "inst-sys-testing"
    }
}

resource "aws_eip" "testing" {
    vpc = true
    instance = "${aws_instance.testing.id}"
}

output "testing_instance_public_ip" {
    value = "${aws_eip.testing.public_ip}"
}