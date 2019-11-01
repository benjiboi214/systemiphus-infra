variable "mmpl_instance_size" {}

resource "null_resource" "mmpl_staging" {
    triggers = {
        private_ip = "${cidrhost(null_resource.subnet_ranges.triggers.public_cidr, 13)}"
    }
}

resource "null_resource" "mmpl_production" {
    triggers = {
        private_ip = "${cidrhost(null_resource.subnet_ranges.triggers.public_cidr, 12)}"
    }
}

resource "aws_instance" "mmpl_staging" {
    ami = "${var.ubuntu_1604_ami}"
    instance_type = "${var.mmpl_instance_size}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.primary_public.id}"
    private_ip = "${null_resource.mmpl_staging.triggers.private_ip}"
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

resource "aws_instance" "mmpl_production" {
    ami = "${var.ubuntu_1604_ami}"
    instance_type = "${var.mmpl_instance_size}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.primary_public.id}"
    private_ip = "${null_resource.mmpl_production.triggers.private_ip}"
    source_dest_check = false
    vpc_security_group_ids = ["${aws_security_group.public.id}"]

    root_block_device {
        volume_type = "standard"
        volume_size = 8
        delete_on_termination = "true"
    }

    tags = {
        Name = "inst-sys-mmpl-production"
    }
}

resource "aws_eip" "mmpl_staging" {
    vpc = true
    instance = "${aws_instance.mmpl_staging.id}"
}

resource "aws_eip" "mmpl_production" {
    vpc = true
    instance = "${aws_instance.mmpl_production.id}"
}

output "mmpl_staging_instance_public_ip" {
    value = "${aws_eip.mmpl_staging.public_ip}"
}

output "mmpl_production_instance_public_ip" {
    value = "${aws_eip.mmpl_production.public_ip}"
}