resource "aws_security_group" "systemiphus_public_sg" {
    name = "systemiphus_public_routes"
    description = "The SG for inbound and outbound rules to the public subnet"
    vpc_id = "${aws_vpc.systemiphus.id}"

    ingress {
        # Allow SSH to public subnet from my IP
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Allow SSH from my public IP"
    }

    egress {
        # Allows anywhere egress for the public subnet
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow access to anywhere from the public subnet"
    }
}

resource "aws_security_group" "systemiphus_private_sg" {
    name = "systemiphus_private_routes"
    description = "The SG for inbound and outbound rules to the private subnet"
    vpc_id = "${aws_vpc.systemiphus.id}"

    ingress {
        # Allows ingress from the bastion host ip for SSH
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = ["${null_resource.bastion_public.triggers.private_ip}/32"]
        description = "Allows ingress from the bastion security group for SSH"
    }

    ingress {
        # REMOVE ME: Allow ingress from NAT instance
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["${null_resource.nat_public.triggers.private_ip}/32"]
        description = "Allow ingress from NAT instance"
    }

    egress {
        # Allows egress to the nat security group for NATing
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["${null_resource.nat_public.triggers.private_ip}/32"]
        description = "Allows egress to the nat security group for NATing"
    }
}

resource "aws_security_group" "systemiphus_nat_sg" {
    name = "systemiphus_nat_routes"
    description = "The SG for inbound and outbound rules to the NAT instance"
    vpc_id = "${aws_vpc.systemiphus.id}"
    depends_on = ["aws_security_group.systemiphus_private_sg"]

    ingress {
        # Allow SSH to NAT instance from my IP
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Allow SSH from my public IP"
    }

    ingress {
        # Allows private subnet access to the nat subnet for internet access
        from_port = 0
        to_port = 0
        protocol = -1
        security_groups = ["${aws_security_group.systemiphus_private_sg.id}"]
        description = "Allow ingress from the private sec group to the public subnet."
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow access to anywhere from the nat subnet"
    }

    ingress {
        # Allow VPN Connection over tcp to bastion host
        from_port = 80
        to_port = 80
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        # Allow VPN Connection over tcp to bastion host
        from_port = 443
        to_port = 443
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "systemiphus_bastion_sg" {
    name = "systemiphus_bastion_security"
    vpc_id = "${aws_vpc.systemiphus.id}"
    description = "The SG for inbound and outbound rules to the NAT instance"
    depends_on = ["aws_security_group.systemiphus_nat_sg"]

    ingress {
        # Allow SSH to bastion instance from my IP
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Allow SSH from my public IP"
    }

    ingress {
        # Allow VPN Connection over tcp to bastion host
        from_port = 443
        to_port = 443
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        # Allow TCP access to the openvpn web console
        from_port = 943
        to_port = 943
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow TCP to the openvpn web console."
    }

    egress {
        # Allows egress to the private SG for SSH
        from_port = 22
        to_port = 22
        protocol = 6
        security_groups = ["${aws_security_group.systemiphus_private_sg.id}"]
        description = "Allows egress to the private SG for VPN connections."
    }
}

