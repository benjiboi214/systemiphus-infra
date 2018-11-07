output "nat_ami" {
    value = "${data.aws_ami.systemiphus_nat_ami.image_id}"
}
resource "aws_instance" "test_public" {
    ami = "ami-8a3f9ae8"
    instance_type = "t2.micro"
    key_name = "systemiphus_ultimate_access"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_public.id}"]
    subnet_id = "${aws_subnet.systemiphus_public_subnet.id}"
}
resource "aws_instance" "test_private" {
    ami = "ami-8a3f9ae8"
    instance_type = "t2.micro"
    key_name = "systemiphus_ultimate_access"
    vpc_security_group_ids = ["${aws_security_group.systemiphus_private.id}"]
    subnet_id = "${aws_subnet.systemiphus_private_subnet.id}"
}