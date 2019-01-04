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

    root_block_device {
        volume_type = "standard"
        volume_size = 8
        delete_on_termination = "true"
    }

    tags {
        role = "openvpn"
        Name = "bastion"
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

    root_block_device {
        volume_type = "standard"
        volume_size = 8
        delete_on_termination = "true"
    }

    tags {
        role = "nat"
        Name = "nat"
        subnet = "public"
        tier = "management"
    }
}

# resource "aws_instance" "jenkins_host" {
#     ami = "${var.systemiphus_ubuntu_ami}"
#     instance_type = "${var.systemiphus_jenkins_host_size}"
#     key_name = "${var.systemiphus_ssh_keyname}"
#     vpc_security_group_ids = ["${aws_security_group.systemiphus_private_sg.id}"]
#     subnet_id = "${aws_subnet.systemiphus_private.id}"

#     root_block_device {
#         volume_type = "gp2"
#         volume_size = 8
#         delete_on_termination = "true"
#     }

#     tags {
#         role = "cicd"
#         Name = "jenkins"
#         subnet = "private"
#         tier = "management"
#     }
# }

resource "aws_instance" "awx_host" {
    ami = "${data.aws_ami.systemiphus_centos_ami.image_id}"
    instance_type = "${var.systemiphus_awx_host_size}"
    key_name = "systemiphus_ultimate_access"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_private_sg.id}"]
    subnet_id = "${aws_subnet.systemiphus_private.id}"
    
    tags {
        role = "config"
        Name = "awx"
        subnet = "private"
        tier = "management"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 30
        delete_on_termination = "true"
    }
}

resource "aws_db_subnet_group" "systemiphus_db_subnet_group" {
  name       = "systemiphus_db_subnet_group"
  subnet_ids = ["${aws_subnet.systemiphus_private.id}", "${aws_subnet.systemiphus_public.id}"]

  tags = {
    Name = "Systemiphus DB subnet group"
  }
}

resource "aws_db_instance" "systemiphus_postgres" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "postgres"
    engine_version = "10.4"
    instance_class = "db.t2.micro"
    name = "systemiphus_db"
    username = "${var.db_master_user}"
    password = "${var.db_master_password}"
    db_subnet_group_name = "${aws_db_subnet_group.systemiphus_db_subnet_group.name}"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_private_sg.id}"]
}

output "The PG Internal Address" {
    value = "${aws_db_instance.systemiphus_postgres.endpoint}"
}