variable "jenkins_instance_size" {}

resource "null_resource" "jenkins" {
    triggers = {
        private_ip = "${cidrhost(null_resource.subnet_ranges.triggers.private_cidr, 10)}"
    }
}

resource "aws_instance" "jenkins" {
    ami = "${var.ubuntu_1604_ami}"
    instance_type = "${var.jenkins_instance_size}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.primary_private.id}"
    private_ip = "${null_resource.jenkins.triggers.private_ip}"
    source_dest_check = false
    vpc_security_group_ids = ["${aws_security_group.private.id}"]

    root_block_device {
        volume_type = "standard"
        volume_size = 8
        delete_on_termination = "true"
    }

    tags = {
        Name = "inst-sys-jenkins"
    }
}

output "jenkins_instance_private_ip" {
    value = "${aws_instance.jenkins.private_ip}"
}