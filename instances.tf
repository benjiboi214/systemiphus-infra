resource "null_resource" "bastion_public" {
    triggers = {
        private_ip = "${cidrhost(null_resource.systemiphus_subnet.triggers.public_cidr, var.systemiphus_bastion_instance_host_number)}"
    }
}

resource "null_resource" "nat_public" {
    triggers = {
        private_ip = "${cidrhost(null_resource.systemiphus_subnet.triggers.public_cidr, var.systemiphus_nat_instance_host_number)}"
    }
}

resource "aws_instance" "bastion_host" {
    ami = "${var.systemiphus_openvpn_ami}"
    instance_type = "${var.systemiphus_bastion_host_size}"
    key_name = "${var.systemiphus_ssh_keyname}"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_bastion_sg.id}"]
    subnet_id = "${aws_subnet.systemiphus_public.id}"
    private_ip = "${null_resource.bastion_public.triggers.private_ip}"

    tags {
        role = "openvpn"
        name = "bastion"
        subnet = "private"
        tier = "management"
    }
}

resource "aws_instance" "nat_host" {
    ami = "${data.aws_ami.systemiphus_nat_ami.image_id}"
    instance_type = "${var.systemiphus_nat_host_size}"
    key_name = "${var.systemiphus_ssh_keyname}"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_nat_sg.id}"]
    subnet_id = "${aws_subnet.systemiphus_public.id}"
    private_ip = "${null_resource.nat_public.triggers.private_ip}"
    source_dest_check = false

    tags {
        role = "nat"
        name = "nat"
        subnet = "public"
        tier = "management"
    }
}

# get rid of private instance for now
resource "aws_instance" "jenkins_host" {
    ami = "${var.systemiphus_ubuntu_ami}"
    instance_type = "${var.systemiphus_jenkins_host_size}"
    key_name = "${var.systemiphus_ssh_keyname}"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_private_sg.id}"]
    subnet_id = "${aws_subnet.systemiphus_private.id}"

    tags {
        role = "cicd"
        name = "jenkins"
        subnet = "private"
        tier = "management"
    }
}

# resource "aws_instance" "tower_host" {
#     ami = "${data.aws_ami.systemiphus_centos_ami.image_id}"
#     instance_type = "t2.micro"
#     key_name = "systemiphus_ultimate_access"
#     vpc_security_group_ids = ["${aws_security_group.systemiphus_private_sg.id}"]
#     subnet_id = "${aws_subnet.systemiphus_private.id}"
    
#     tags {
#         role = "config"
#         name = "ansible_awx"
#         subnet = "private"
#         tier = "management"
#     }
# }