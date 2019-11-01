variable "mmpl_instance_size" {}

resource "null_resource" "mmpl" {
    triggers = {
        private_ip = "${cidrhost(null_resource.subnet_ranges.triggers.public_cidr, 11)}"
    }
}

resource "aws_instance" "mmpl" {
    ami = "${var.ubuntu_1604_ami}"
    instance_type = "${var.mmpl_instance_size}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.primary_public.id}"
    private_ip = "${null_resource.mmpl.triggers.private_ip}"
    source_dest_check = false
    vpc_security_group_ids = ["${aws_security_group.public.id}"]

    root_block_device {
        volume_type = "standard"
        volume_size = 8
        delete_on_termination = "true"
    }

    tags = {
        Name = "inst-sys-mmpl-staging"
    }
}

resource "aws_eip" "mmpl" {
    vpc = true
    instance = "${aws_instance.mmpl.id}"
}

output "mmpl_instance_public_ip" {
    value = "${aws_eip.mmpl.public_ip}"
}