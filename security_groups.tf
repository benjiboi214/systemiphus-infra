## Public Group
resource "aws_security_group" "public" {
    name = "sys-primary-public"
    description = "The SG for inbound and outbound rules to the public subnet"
    vpc_id = "${aws_vpc.primary.id}"

    ingress {
        # Egress to Anywhere over Any Protocol from Public SG
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Ingress anywhere over SSH for the public SG"
    }

    ingress {
        # Egress to Anywhere over Any Protocol from Public SG
        from_port = 1194
        to_port = 1194
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Ingress anywhere over SSH for the public SG"
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

## Private Group
resource "aws_security_group" "private" {
    name = "sys-primary-private"
    description = "The SG for inbound and outbound rules to the private subnet"
    vpc_id = "${aws_vpc.primary.id}"

    ingress {
        # Egress to Anywhere over Any Protocol from Public SG
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Inress from Anywhere over Any Protocol from Private SG"
    }

    egress {
        # Egress to Anywhere over Any Protocol from Public SG
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Egress to Anywhere over Any Protocol from Private SG"
    }
}