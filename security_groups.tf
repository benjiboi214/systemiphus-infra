// Define the security groups and access levels for everything here.
resource "aws_security_group" "systemiphus_public" {
    name = "systemiphus_public_routes"
    description = "The SG for inbound and outbound rules to the public subnet"
    vpc_id = "${aws_vpc.systemiphus.id}"

    # # From private subnet to NAT gateway 80 & 443
    # ingress {
    #     from_port = 80
    #     to_port = 80
    #     protocol = 6
    #     cidr_blocks = "${aws_subnet.systemiphus_private_subnet.cidr_blocks}"
    # }
    # ingress {
    #     from_port = 443
    #     to_port = 443
    #     protocol = 6
    #     cidr_blocks = "${aws_subnet.systemiphus_private_subnet.cidr_blocks}"
    # }

    # # From internet to webservers
    # ingress {
    #     from_port = 80
    #     to_port = 80
    #     protocol = 6
    #     cidr_blocks = "0.0.0.0/0"
    # }
    # ingress {
    #     from_port = 443
    #     to_port = 443
    #     protocol = 6
    #     cidr_blocks = "0.0.0.0/0"
    # }

    # To anywhere, any protocol, any port

}

resource "aws_security_group" "systemiphus_private" {
    name = "systemiphus_private_routes"
    description = "The SG for inbound and outbound rules to the private subnet"
    vpc_id = "${aws_vpc.systemiphus.id}"
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

