resource "null_resource" "systemiphus_nat_instance" {
    triggers = {
        private_ip = "${cidrhost(null_resource.systemiphus_subnet.triggers.public_cidr, var.systemiphus_nat_instance_host_number)}"
    }
}

resource "aws_instance" "bastion_host" {
    ami = "${data.aws_ami.systemiphus_nat_ami.image_id}"
    instance_type = "${var.systemiphus_bastion_host_size}"
    key_name = "${var.systemiphus_ssh_keyname}"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_nat_sg.id}"]
    subnet_id = "${aws_subnet.systemiphus_public_subnet.id}"
    private_ip = "${null_resource.systemiphus_nat_instance.triggers.private_ip}"
    source_dest_check = false

    tags {
        role = "nat"
        name = "bastion"
        subnet = "public"
        tier = "management"
    }
}

# get rid of private instance for now
resource "aws_instance" "jenkins_host" {
    ami = "${data.aws_ami.systemiphus_centos_ami.image_id}"
    instance_type = "t2.micro"
    key_name = "systemiphus_ultimate_access"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_private_sg.id}"]
    subnet_id = "${aws_subnet.systemiphus_private_subnet.id}"

    tags {
        role = "cicd"
        name = "jenkins"
        subnet = "private"
        tier = "management"
    }
}

resource "aws_instance" "tower_host" {
    ami = "${data.aws_ami.systemiphus_centos_ami.image_id}"
    instance_type = "t2.micro"
    key_name = "systemiphus_ultimate_access"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_private_sg.id}"]
    subnet_id = "${aws_subnet.systemiphus_private_subnet.id}"
    
    tags {
        role = "config"
        name = "ansible_awx"
        subnet = "private"
        tier = "management"
    }
}