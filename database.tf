variable "db_master_username" {}

variable "db_master_password" {}


# resource "aws_db_subnet_group" "primary" {
#   name       = "sys-primary"
#   subnet_ids = ["${aws_subnet.primary_private_a.id}", "${aws_subnet.primary_private_b.id}"]
# }

# resource "aws_db_instance" "postgres" {
#     allocated_storage = 20
#     storage_type = "gp2"
#     engine = "postgres"
#     engine_version = "10.6"
#     instance_class = "db.t2.micro"
#     name = "systemiphus_db"
#     username = "${var.db_master_username}"
#     password = "${var.db_master_password}"
#     db_subnet_group_name = "${aws_db_subnet_group.primary.name}"
#     vpc_security_group_ids = ["${aws_security_group.private.id}"]
# }

# output "postgres_internal_dns" {
#     value = "${aws_db_instance.postgres.endpoint}"
# } 