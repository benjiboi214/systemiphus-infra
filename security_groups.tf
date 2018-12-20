resource "aws_security_group" "systemiphus_public_sg" {
    name = "systemiphus_public_routes"
    description = "The SG for inbound and outbound rules to the public subnet"
    vpc_id = "${aws_vpc.systemiphus.id}"

    ingress {
        # Ingress from My IP over SSH to Public SG
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Ingress from My IP over SSH to Public SG"
    }

    egress {
        # Egress to Anywhere over Any Protocol from Public SG
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Egress to Anywhere over Any Protocol from Public SG"
    }
}

resource "aws_security_group" "systemiphus_private_sg" {
    name = "systemiphus_private_routes"
    description = "The SG for inbound and outbound rules to the private subnet"
    vpc_id = "${aws_vpc.systemiphus.id}"

    ingress {
        # Ingress from Bastion IP over SSH to Private SG
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = ["${null_resource.bastion_public.triggers.private_ip}/32"]
        description = "Ingress from Bastion IP over SSH to Private SG"
    }

    ingress {
        # Ingress from Bastion IP over HTTP to Private SG
        from_port = 80
        to_port = 80
        protocol = 6
        cidr_blocks = ["${null_resource.bastion_public.triggers.private_ip}/32"]
        description = "Ingress from Bastion IP over HTTP to Private SG"
    }

    ingress {
        # Ingress from Bastion IP over HTTPS to Private SG
        from_port = 443
        to_port = 443
        protocol = 6
        cidr_blocks = ["${null_resource.bastion_public.triggers.private_ip}/32"]
        description = "Ingress from Bastion IP over HTTPS to Private SG"
    }

    ingress {
        # Ingress from NAT IP over Any Protocol to Private SG
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["${null_resource.nat_public.triggers.private_ip}/32"]
        description = "Ingress from NAT IP over Any Protocol to Private SG"
    }

    ingress {
        # Allows ingress to self from self
        from_port = 0
        to_port = 0
        protocol = -1
        self = true
        description = "Allows ingress to self from self"
    }

    egress {
        # Egress to Anywhere over Any Protocol from Private SG
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allows egress to the nat security group for NATing"
    }
}

resource "aws_security_group" "systemiphus_nat_sg" {
    name = "systemiphus_nat_routes"
    description = "The SG for inbound and outbound rules to the NAT instance"
    vpc_id = "${aws_vpc.systemiphus.id}"

    ingress {
        # Ingress from My IP over SSH to NAT SG
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Ingress from My IP over SSH to NAT SG"
    }

    ingress {
        # Ingress from Private CIDR over 80 to NAT SG
        from_port = 80
        to_port = 80
        protocol = 6
        cidr_blocks = ["${null_resource.systemiphus_subnet.triggers.private_cidr}"]
        description = "Ingress from Private CIDR over 80 to NAT SG"
    }

    ingress {
        # Ingress from Private CIDR over 443 to NAT SG
        from_port = 443
        to_port = 443
        protocol = 6
        cidr_blocks = ["${null_resource.systemiphus_subnet.triggers.private_cidr}"]
        description = "Ingress from Private CIDR over 443 to NAT SG"
    }

    egress {
        # Egress to anywhere from NAT SG on any port
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Egress to anywhere from NAT SG on any port"
    }

}

resource "aws_security_group" "systemiphus_bastion_sg" {
    name = "systemiphus_bastion_security"
    vpc_id = "${aws_vpc.systemiphus.id}"
    description = "The SG for inbound and outbound rules to the NAT instance"
    depends_on = ["aws_security_group.systemiphus_nat_sg"]

    ingress {
        # Ingress from My IP over SSH to Bastion SG
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Ingress from My IP over SSH to Bastion SG"
    }

    ingress {
        # Ingress from My IP over 443 to Bastion SG
        from_port = 443
        to_port = 443
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Ingress from My IP over 443 to Bastion SG"
    }

    ingress {
        # Ingress from My IP over 943 to Bastion SG
        from_port = 943
        to_port = 943
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Ingress from My IP over 943 to Bastion SG"
    }

    egress {
        # Egress to Private SG over SSH from Bastion SG
        from_port = 22
        to_port = 22
        protocol = 6
        security_groups = ["${aws_security_group.systemiphus_private_sg.id}"]
        description = "Allows egress to the private SG for VPN connections."
    }

    egress {
        # Egress to Anywhere over Any Protocol from Bastion SG
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Egress to Anywhere over Any Protocol from Bastion SG"
    }
}

