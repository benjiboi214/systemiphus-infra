// Define the security groups and access levels for everything here.
resource "aws_security_group" "systemiphus_public_sg" {
    name = "systemiphus_public_routes"
    description = "The SG for inbound and outbound rules to the public subnet"
    vpc_id = "${aws_vpc.systemiphus.id}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        security_groups = ["${aws_security_group.systemiphus_private_sg.id}"]
        description = "Allow ingress from the private sec group to the public subnet."
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Allow SSH from my public IP"
    }

    egress {
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
        from_port = 0
        to_port = 0
        protocol = -1
        self = true
        description = "Allow ingress inside the private security group"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        self = true
        description = "Allow egress inside the private security group"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = ["${null_resource.systemiphus_nat_instance_public.triggers.private_ip}/32"]
        description = "Allow SSH access from the NAT instance IP."
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${null_resource.systemiphus_nat_instance_public.triggers.private_ip}/32"]
        description = "Allow icmp to public security group from my public IP"
    }

}

resource "aws_security_group" "systemiphus_nat_sg" {
    name = "systemiphus_nat_routes"
    description = "The SG for inbound and outbound rules to the NAT instance"
    vpc_id = "${aws_vpc.systemiphus.id}"
    depends_on = ["aws_security_group.systemiphus_private_sg"]

    ingress {
        from_port = 22
        to_port = 22
        protocol = 6
        cidr_blocks = "${var.belliot_current_public_ip}"
        description = "Allow SSH from my public IP"
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        security_groups = ["${aws_security_group.systemiphus_private_sg.id}"]
        description = "Allow the private security group to access the NAT instance"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
    }

    
    ingress {
        from_port = 943
        to_port = 943
        protocol = 6
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow access to anywhere from the nat subnet"
    }
}
### Public
## Inbound
# from current SG, All protocols, all ports
# NAT Settings
# from private subnet, TCP 80
# from private subnet, TCP 443
# webserver settings
# from anywhere TCP 80
# from anywhere TCP 443

## Outbound
# Basic Settings
# to anywhere, all prots, all ports
# Forwards SSH internally to private subnet (Optionals)
# to private subnet, TCP 22
# LATER: Provide access to DB Server in prtivate subnet


## Private
# Inbound
# from current SG, all prot, all port
# from public subnet, all prot, all port

# Outbound
# to the current SG, all prot, all port
# to NAT instance, TCP 80
# to NAT instance, TCP 443

